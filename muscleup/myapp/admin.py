from django.contrib import admin
from .models import *

admin.site.register(User)
admin.site.register(Profile)
admin.site.register(Coach)
admin.site.register(Offer)
admin.site.register(Session)
admin.site.register(Availability)
admin.site.register(Message)
admin.site.register(Notification)
admin.site.register(Feedback)