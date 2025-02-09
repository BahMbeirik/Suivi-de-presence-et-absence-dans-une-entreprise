from rest_framework import serializers
from .models import CustomUser, WorkDay

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = CustomUser
        fields = ['username', 'email', 'phone_number', 'password']

    def create(self, validated_data):
        user = CustomUser.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            phone_number=validated_data['phone_number'],
            password=validated_data['password'],
        )
        user.is_active = True  # Désactiver l'utilisateur jusqu'à la vérification OTP
        user.save()
        return user



class LoginSerializer(serializers.Serializer):
    phone_number = serializers.CharField(max_length=8)
    password = serializers.CharField(write_only=True)

class VerifyLoginOTPSerializer(serializers.Serializer):
    phone_number = serializers.CharField(max_length=8)
    otp = serializers.CharField(max_length=6)


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['id', 'username', 'email', 'phone_number', 'is_phone_verified']


class WorkDaySerializer(serializers.ModelSerializer):
    class Meta:
        model = WorkDay
        fields = ['date', 'arrival_time', 'departure_time']