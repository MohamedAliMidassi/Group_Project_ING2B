import re
from django.db import models
from django.contrib.auth.models import AbstractUser
from django.core.validators import MinValueValidator, MaxValueValidator
from django.core.exceptions import ValidationError




def validate_email_regex(value):
    #*Custom regex pattern
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    if not re.match(pattern, value):
        raise ValidationError('Invalid email format')
    



def validate_phone_regex(value):
    pattern = r'^\+?[0-9]{10,15}$'
    if not re.match(pattern, value):
        raise ValidationError('Phone number must be 10-15 digits, optionally starting with +')
    



#? Custom User model using Django's AbstractUser  and regex validation for email field 
    #!check documontation for the usage of AbstractUser "https://forum.djangoproject.com/t/how-to-create-custom-users-with-different-roles-types/20772/10"
class User(AbstractUser):
    user_type_choices = (
        ('client','CLIENt'),
        ('coach','COACH'))
    email = models.EmailField(
        max_length=254,
        validators=[validate_email_regex]
    )
    username=models.CharField(max_length=150, unique=True)
    user_type = models.CharField(max_length=10, choices=user_type_choices)
    #! apperantly we dont need the password anf the confirm password fields because the abstract user model has one already and its hashed
    """
    password=models.CharField(max_length=128)
    confirm_password=models.CharField(max_length=128)
    """
    created_at=models.DateTimeField(auto_now_add=True)
    updated_at=models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.username} {self.get_user_type_display()}"

#? user profile details,client specific informations the full name an avatr bio that contains a brief discription about the user a phone number and the location of the client
#?the phone number is validated using a custom validator "regex"
class Profile(models.Model):
    #*Clirent informations
    user=models.OneToOneField(User, on_delete=models.CASCADE, related_name='client_profile')#! the relationship between the user model and the client profile
    full_name=models.CharField(max_length=255, blank=True)
    avatar=models.ImageField(upload_to='avatars/', blank=True, null=True)
    bio=models.TextField(blank=True)        
    phone = models.CharField(
        max_length=20, 
        blank=True,
        validators=[validate_phone_regex]
    )
    location=models.CharField(max_length=255, blank=True)


    def __str__(self):
        return f"the  profile of: {self.user.username}"


#? Coach profile details ,his exerpertise experience years and his rating his session count with us avilability.
#?with the methose to update his rating based on the feedback recived from clients 
class Coach(models.Model):
    #* Coach informations
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='coach_profile')#! the relationship between the user model and the coach profile
    full_name=models.CharField(max_length=255, blank=True)
    expertise = models.CharField(max_length=255, blank=True)
    experience_years = models.PositiveIntegerField(default=0)
    rating = models.DecimalField(max_digits=3, decimal_places=2, default=0)
    sessions_count = models.PositiveIntegerField(default=0)


    def __str__(self):
        return f"The profile of : {self.user.username}"

    def update_rating(self):
        #? Update coach rating based on vlient feedback
        feedbacks = self.feedback_received.all()
        if feedbacks.exists():
            avg_rating = feedbacks.aggregate(models.Avg('rating'))['rating__avg']
            self.rating = round(avg_rating, 2)
            self.save()


#? The user find the coach that has the offers that suits him he will find the offer the ame of coach name of the offer price duration time and the availabilty of the offer
#? here you can find the package offer posted by the coach and you can book this session but the time is pre ditermend by the coach
class Offer(models.Model):
    #? Pricing packages offers by coaches
    coach = models.ForeignKey(Coach, on_delete=models.CASCADE, related_name='offers')#! you need to link the coach with the offer to know wich coach has that offer
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    duration = models.PositiveIntegerField()
    availability = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at=models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.name} - ${self.price} ({self.duration} minutes) by {self.coach.user.username})"


#? the user here will find a form to book a session he will fill by the date he want the satrt and end time and the coach will confirm the seesion or reject it and he will determin the price
#? here you find the one on one session with the coach and you can book a session with him and you chose the time that suits you
class Session(models.Model):
    #? Booked sessions between clients and coaches
    STATUS_CHOICES = (
        ('pending', 'Pending'),
        ('confirmed', 'Confirmed'),
        ('rejected', 'Rejected'),
        ('completed', 'Completed'),
        ('cancelled', 'Cancelled'),
    )
    
    client = models.ForeignKey(User, on_delete=models.CASCADE, related_name='client_sessions') #!the relationship between the client and the seesion
    coach = models.ForeignKey(User, on_delete=models.CASCADE, related_name='coach_sessions') #!the relationship between the coach and the seesion
    session_date = models.DateField()
    start = models.TimeField()
    end = models.TimeField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    price = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at=models.DateTimeField(auto_now=True)
    


    def __str__(self):
        return f"Session: {self.client.username} with {self.coach.username} on {self.session_date}"



#? this is a messagerie between the coach and the client that they are free to disscus what ever they want
class Message(models.Model):
    session = models.ForeignKey(Session, on_delete=models.SET_NULL, null=True, blank=True, related_name='messages')
    sender = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sent_messages')
    receiver = models.ForeignKey(User, on_delete=models.CASCADE, related_name='received_messages')
    message = models.TextField()
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at=models.DateTimeField(auto_now=True)


    def __str__(self):
        return f"Message from {self.sender.username} to {self.receiver.username}"
#?this is the feedback the client leaves to the coachs with a rate and a comment 
class Feedback(models.Model):
    session = models.OneToOneField(Session, on_delete=models.CASCADE, related_name='feedback')
    client = models.ForeignKey(User, on_delete=models.CASCADE, related_name='client_feedback')
    coach = models.ForeignKey(User, on_delete=models.CASCADE, related_name='coach_feedback')
    rating = models.PositiveIntegerField(validators=[MinValueValidator(1), MaxValueValidator(5)])
    comment = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Feedback: {self.rating}/5 for session {self.session.id}"


#? here the coach determin his working hours and the days he will be available to recive clients offers
class Availability(models.Model):
    #? Coach availability schedule
    DAYS_OF_WEEK = (
        ('Monday', 'Monday'),
        ('Tuesday', 'Tuesday'),
        ('Wednesday', 'Wednesday'),
        ('Thursday', 'Thursday'),
        ('Friday', 'Friday'),
        ('Saturday', 'Saturday'),
        ('Sunday', 'Sunday'),
    )
    
    coach = models.ForeignKey(Coach, on_delete=models.CASCADE, related_name='availability')
    day= models.CharField(max_length=10, choices=DAYS_OF_WEEK)
    start= models.TimeField()
    end = models.TimeField()
    is_available = models.BooleanField(default=True)
    

    def __str__(self):
        return f"{self.coach.user.username} - {self.day}: {self.start} to {self.end}"


#? this is the notification tezmplate of the message and the sessions updates
class Notification(models.Model):
    NOTIFICATION_TYPES = (
        ('session_reminder', 'Session Reminder'),
        ('message', 'New Message'),
        ('booking', 'Booking Confirmation'),
        ('cancellation', 'Session Cancelled'),
    )
    
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='notifications')
    title = models.CharField(max_length=255)
    message = models.TextField()
    notification_type = models.CharField(max_length=20, choices=NOTIFICATION_TYPES)
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Notification for {self.user.username}: {self.title}"