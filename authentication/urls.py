from django.urls import path
from authentication.views import LoginView, RegisterView, VerifyOTPView, end_day, get_all_users, get_user, get_user_attendance, get_workdays, start_day, today, update_user

urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('verify-otp/', VerifyOTPView.as_view(), name='verify-otp'),
    path('today/', today, name='today'),
    path('end-day/', end_day, name='end_day'),
    path('start-day/', start_day, name='start_day'),
    path('workdays/', get_workdays, name='get_workdays'),
    path('user/', get_user, name='get_user'),  
    path('user/update/', update_user, name='update_user'),
    path('admin/users/', get_all_users, name='get_all_users'),
    path('admin/user/<int:user_id>/attendance/', get_user_attendance, name='get_user_attendance'),

]