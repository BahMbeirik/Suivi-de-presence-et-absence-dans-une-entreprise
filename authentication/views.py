from datetime import datetime ,date
from django.contrib.auth.models import User
from django.forms import ValidationError
from django.shortcuts import render
from django.http import JsonResponse
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
import random
from django.core.cache import cache
from rest_framework.permissions import AllowAny
from authentication.models import CustomUser
from .utils import send_sms
from authentication.serializers import RegisterSerializer, UserSerializer, WorkDaySerializer
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .models import WorkDay
from rest_framework.permissions import IsAdminUser


class RegisterView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        print("Request Data:", request.data)  # Debugging
        phone_number = request.data.get('phone_number')
        username = request.data.get('username')
        email = request.data.get('email')
        password = request.data.get('password')

        if not all([phone_number, username, email, password]):
            return Response({"error": "All fields are required."}, status=status.HTTP_400_BAD_REQUEST)

        # Créer l'utilisateur
        user = CustomUser.objects.create_user(username=username, email=email, password=password, phone_number=phone_number)
        user.is_active = True  # Désactiver l'utilisateur jusqu'à la vérification
        user.save()

        return Response({"message": "User registered. Verify OTP to activate account."}, status=status.HTTP_201_CREATED)


class LoginView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        print("Request Data:", request.data)  
        phone_number = request.data.get('phone_number')
        password = request.data.get('password')

        if not phone_number or not password:
            return Response({"error": "Phone number and password are required."}, status=status.HTTP_400_BAD_REQUEST)

        # Retrieve the user using the CustomUser model
        user = CustomUser.objects.filter(phone_number=phone_number).first()

        if not user or not user.check_password(password):
            return Response({"error": "Invalid credentials."}, status=status.HTTP_400_BAD_REQUEST)

        # Send OTP via SMS and get the OTP from the response
        success, otp = send_sms(phone_number)  
        if not success:
            return Response({"error": f"Failed to send OTP: {otp}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # Store OTP in cache
        cache.set(phone_number, otp, timeout=300)  # Store OTP for 5 minutes

        return Response(
            {
                "message": "OTP sent for login verification.",
                "role": "admin" if user.is_superuser else "user"
            },
            status=status.HTTP_200_OK
        )
    
class VerifyOTPView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        phone_number = request.data.get('phone_number')
        otp = request.data.get('otp')

        # Retrieve the user using the CustomUser model
        user = CustomUser.objects.filter(phone_number=phone_number).first()

        # Retrieve OTP from cache
        cached_otp = cache.get(phone_number)


        if user and cached_otp and str(cached_otp) == str(otp):
            # Generate JWT tokens
            refresh = RefreshToken.for_user(user)
            return Response({
                'token': str(refresh.access_token),
            }, status=status.HTTP_200_OK)

        return Response({'error': 'Invalid OTP'}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def today(request):
    user = request.user
    today_date = date.today()

    try:
        workday = WorkDay.objects.get(user=user, date=today_date)
        data = {
            'arrivalTime': workday.arrival_time.strftime('%H:%M') if workday.arrival_time else '--:--',
            'departureTime': workday.departure_time.strftime('%H:%M') if workday.departure_time else '--:--',
        }
    except WorkDay.DoesNotExist:
        data = {
            'arrivalTime': '--:--',
            'departureTime': '--:--',
        }

    return Response(data)



@api_view(['POST'])
@permission_classes([IsAuthenticated])
def start_day(request):
    user = request.user
    today_date = date.today()

    
    workday, created = WorkDay.objects.get_or_create(user=user, date=today_date)

    
    if workday.arrival_time:
        return Response({
            'message': 'La journée a déjà commencé.',
            'arrivalTime': workday.arrival_time.strftime('%H:%M'),
        }, status=status.HTTP_200_OK)

    arrival_time = request.data.get('arrivalTime')
    if not arrival_time:
        return Response({'error': 'arrivalTime is required.'}, status=status.HTTP_400_BAD_REQUEST)

    try:
        arrival_time_obj = datetime.strptime(arrival_time, '%H:%M').time()
    except ValueError:
        return Response({'error': 'arrivalTime must be in HH:MM format.'}, status=status.HTTP_400_BAD_REQUEST)

    workday.arrival_time = arrival_time_obj
    workday.save()

    return Response({
        'message': 'Workday started successfully',
        'arrivalTime': workday.arrival_time.strftime('%H:%M'),
    })



@api_view(['POST'])
@permission_classes([IsAuthenticated])
def end_day(request):
    user = request.user
    today_date = date.today()

    try:
        workday = WorkDay.objects.get(user=user, date=today_date)
    except WorkDay.DoesNotExist:
        return Response({'error': 'No workday found for today.'}, status=status.HTTP_404_NOT_FOUND)

    if workday.departure_time:
        return Response({
            'message': 'La journée est déjà terminée.',
            'departureTime': workday.departure_time.strftime('%H:%M'),
        }, status=status.HTTP_200_OK)

    departure_time_str = request.data.get('departureTime')
    if not departure_time_str:
        return Response({'error': 'departureTime is required.'}, status=status.HTTP_400_BAD_REQUEST)

    try:
        departure_time_obj = datetime.strptime(departure_time_str, '%H:%M').time()
    except ValueError:
        return Response({'error': 'departureTime must be in HH:MM format.'}, status=status.HTTP_400_BAD_REQUEST)

    workday.departure_time = departure_time_obj
    workday.save()

    return Response({
        'message': 'Workday ended successfully',
        'departureTime': workday.departure_time.strftime('%H:%M'),
    })


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_workdays(request):
    user = request.user
    workdays = WorkDay.objects.filter(user=user).order_by('-date')  # ترتيب السجلات من الأحدث إلى الأقدم
    serializer = WorkDaySerializer(workdays, many=True)
    return Response(serializer.data)



@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user(request):
    user = request.user
    serializer = UserSerializer(user)
    return Response(serializer.data)



@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_user(request):
    user = request.user
    serializer = UserSerializer(user, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=400)


@api_view(['GET'])
@permission_classes([IsAdminUser])
def get_all_users(request):
    users = CustomUser.objects.all()
    serializer = UserSerializer(users, many=True)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAdminUser])
def get_user_attendance(request, user_id):
    try:
        user = CustomUser.objects.get(id=user_id)
        workdays = WorkDay.objects.filter(user=user).order_by('-date')
        serializer = WorkDaySerializer(workdays, many=True)
        return Response(serializer.data)
    except CustomUser.DoesNotExist:
        return Response({'error': 'User not found'}, status=404)


class ForgotPasswordView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        phone_number = request.data.get('phone_number')
        user = CustomUser.objects.filter(phone_number=phone_number).first()

        if not user:
            return Response({"error": "Phone number not registered"}, status=status.HTTP_400_BAD_REQUEST)

        success, otp = send_sms(phone_number)
        if not success:
            return Response({"error": "Failed to send OTP"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        cache.set(phone_number, otp, timeout=300)  # Store OTP for 5 minutes
        return Response({"message": "OTP sent"}, status=status.HTTP_200_OK)
    
class ResetPasswordView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        phone_number = request.data.get('phone_number')
        otp = request.data.get('otp')
        new_password = request.data.get('new_password')

        user = CustomUser.objects.filter(phone_number=phone_number).first()
        cached_otp = cache.get(phone_number)

        if not user or not cached_otp or str(cached_otp) != str(otp):
            return Response({"error": "Invalid OTP"}, status=status.HTTP_400_BAD_REQUEST)

        user.set_password(new_password)
        user.save()

        return Response({"message": "Password reset successful"}, status=status.HTTP_200_OK)