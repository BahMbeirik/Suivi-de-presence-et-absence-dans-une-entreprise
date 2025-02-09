from django.contrib.auth.models import AbstractUser
from django.db import models

class CustomUser(AbstractUser):
    phone_number = models.CharField(max_length=8, unique=True, null=True, blank=True)
    is_phone_verified = models.BooleanField(default=False)  

    def __str__(self):
        return self.username

class WorkDay(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='workdays')
    date = models.DateField(auto_now_add=True)  
    arrival_time = models.TimeField(null=True, blank=True)
    departure_time = models.TimeField(null=True, blank=True)

    def __str__(self):
        return f"{self.user.username} - {self.date} - Arrival: {self.arrival_time}, Departure: {self.departure_time}"