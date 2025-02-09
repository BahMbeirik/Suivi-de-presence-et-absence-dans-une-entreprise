from django.contrib import admin

from authentication.models import CustomUser, WorkDay

# Register your models here.

admin.site.register(CustomUser)
admin.site.register(WorkDay)