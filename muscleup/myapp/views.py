from myapp.models import *
import json #! convert the information from python to json and the opposite is also correct
from django import forms#! this for coustom forms and validations 
from django.http import JsonResponse#! this is for postman
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods#! it limits the http request to a specific type
from django.contrib.auth import login,logout
from django.contrib.auth.forms import UserCreationForm#! built in from to creat users with password hashingand validation
from django.contrib.auth.forms import AuthenticationForm#! built in fonction to handle the login process
from django.contrib.auth.decorators import login_required#! this is the when somthing that involves delicate informations and we waant that only the user access it


class CustomUserCreationForm(UserCreationForm):
    user_type = forms.ChoiceField(choices=[('client', 'Client'), ('coach', 'Coach')])
    
    class Meta:
        model = User
        fields = ('username', 'email', 'password1', 'password2', 'user_type')
    
    def email(self):
        email = self.cleaned_data.get('email')
        if User.objects.filter(email__iexact=email).exists():
            raise forms.ValidationError('Email already exists')
        return email
#? when you first click on the register button the visitor will land in a new page where he will fill the profile information and it need to be verified 
#? if the user complete the profile informations the user will be redirected to "/api/client/profile/create/" if the user created a client account
#?or "/api/coach/profile/create/"  if the user created a coach account
#? he will fill the profile information and submit it and he have to respect the validation rules
@csrf_exempt
@require_http_methods(["POST"])
def register(request):
    """POST - the registration of an user
    postman body example:
    {
    "username": "ahmed",
    "email": "ahmed@gmail.com",
    "password": "Test123.",
    "password2": "Test123.",
    "user_type": "client"
    }
    """


    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)
    


    #? this is a form created to handle the api request the validation and the hashing
    form_data = {
        'username': data.get('username', ''),
        'email': data.get('email', ''),
        'password1': data.get('password', ''),
        'password2': data.get('password2', ''),
        'user_type': data.get('user_type', '')
    }
    
    form = CustomUserCreationForm(form_data)
    
    if form.is_valid():
        user = form.save()

        login(request, user)#! this is to automatic login the user after the registaration because the handling of the client or the coach profile need you to be logged in
        
        #? creation of the profile based of the user type
        redirect_endpoint = None
        if form.cleaned_data['user_type'] == 'client':
            Profile.objects.create(user=user)
            redirect_endpoint = '/api/client/profile/create/'
        else:
            Coach.objects.create(user=user)
            redirect_endpoint = '/api/coach/profile/create/'
        
        return JsonResponse({
            'message': 'User created successfully',
            'id': user.id,
            'username': user.username,
            'email': user.email,
            'user_type': user.user_type,
            'requires_profile_completion': True,
            'redirect_endpoint': redirect_endpoint
        }, status=201)
    else:
        return JsonResponse({'errors': form.errors}, status=400)

@csrf_exempt
@require_http_methods(["POST"])
def user_login(request):
    """
    POST - the login of an user
    postman body example:
    {
        "username": "string",
        "password": "string"
    }
    """
    
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON format'}, status=400)
    
    #? django built in form to vazlidate the login credintails
    form = AuthenticationForm(request, data={
        'username': data.get('username', ''),
        'password': data.get('password', '')
    })
    
    #? if the form is valid it will return the user crediantels
    if form.is_valid():
        user = form.get_user()
        

        
        #? profile info based on the type of user
        profile_info = {}
        if user.user_type == 'client':
            if hasattr(user, 'client_profile'):
                profile = user.client_profile
                profile_info = {
                    'full_name': profile.full_name,
                    'avatar': str(profile.avatar) if profile.avatar else None,
                    'bio': profile.bio,
                    'phone': profile.phone,
                    'location': profile.location
                }
        elif user.user_type == 'coach':
            if hasattr(user, 'coach_profile'):
                profile = user.coach_profile
                profile_info = {
                    'full_name': profile.full_name,
                    'expertise': profile.expertise,
                    'experience_years': profile.experience_years,
                    'rating': float(profile.rating),
                    'sessions_count': profile.sessions_count
                }
        
        response_data = {
            'message': 'Login successful',
            'user': {
                'id': user.id,
                'username': user.username,
                'email': user.email,
                'user_type': user.user_type,
                'first_name': user.first_name,
                'last_name': user.last_name,
                'date_joined': user.date_joined.isoformat(),
                'last_login': user.last_login.isoformat() if user.last_login else None,
                'profile': profile_info
            }
        }
        
        return JsonResponse(response_data, status=200)
    else:
        #? if the form is invalid it will raise an error
        errors = {}
        for field, error_list in form.errors.items():
            errors[field] = error_list
        
        return JsonResponse({
            'error': 'Invalid username or password',
            'details': errors
        }, status=401)
    

@csrf_exempt
@require_http_methods(["POST"])
def user_logout(request):
        #? POST - Logout user
    if request.user.is_authenticated:
        logout(request)
        return JsonResponse({'message': 'Logout successful'}, status=200)
    else:
        return JsonResponse({'error': 'No user is logged in'}, status=400)

@csrf_exempt
@require_http_methods(["POST", "PUT", "PATCH"])
@login_required
def client_profile(request):
    """
    POST the user profile upgraded to a client profile
    postman body example:
    {
        "full_name": "string",
        "phone": "string",
        "bio": "string (optional)",
        "location": "string (optional)",
        "avatar": "file (optional)"
    }
    """

    if not request.user.is_authenticated:
        return JsonResponse({'error': 'Authentication required'}, status=401)
    
    #? Check if user is a client
    if request.user.user_type != 'client':
        return JsonResponse({'error': 'User is not a client'}, status=400)
    
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON format'}, status=400)
    
    profile, created = Profile.objects.get_or_create(user=request.user)
    
    updated_fields = []
    
    #? Update profile fields
    if 'full_name' in data and data['full_name']:
        profile.full_name = data['full_name']
        updated_fields.append('full_name')
    
    if 'phone' in data and data['phone']:
        #? raise an error if the phone number is invalid using regex
        from django.core.exceptions import ValidationError
        from .models import validate_phone_regex
        try:
            validate_phone_regex(data['phone'])
            profile.phone = data['phone']
            updated_fields.append('phone')
        except ValidationError as e:
            return JsonResponse({'error': str(e)}, status=400)
    
    if 'bio' in data:
        profile.bio = data['bio']
        updated_fields.append('bio')
    
    if 'location' in data:
        profile.location = data['location']
        updated_fields.append('location')
    
    profile.save()
    
    is_complete = bool(profile.full_name and profile.phone)
    
    response_data = {
        'message': 'Client profile saved successfully' if not created else 'Client profile created successfully',
        'profile': {
            'full_name': profile.full_name,
            'phone': profile.phone,
            'bio': profile.bio,
            'location': profile.location,
            'avatar': str(profile.avatar) if profile.avatar else None,
            'is_complete': is_complete
        },
        'updated_fields': updated_fields
    }
    
    #? redirect to dashboard after complition
    if is_complete and request.method != 'GET':
        response_data['profile_complete'] = True
        response_data['next_endpoint'] = '/api/client/dashboard/'
    
    return JsonResponse(response_data, status=200)


@csrf_exempt
@require_http_methods(["POST", "PUT", "PATCH"])
@login_required
def coach_profile(request):
    """
    POST the user profile upgraded to a coach profile
    postman body example: {
        "full_name": "string",
        "expertise": "string",
        "experience_years": "integer",
        "rating": "decimal (optional, default 0)"
    }
    """
    
    if not request.user.is_authenticated:
        return JsonResponse({'error': 'Authentication required'}, status=401)
    
    #? Check if user is a coach
    if request.user.user_type != 'coach':
        return JsonResponse({'error': 'User is not a coach'}, status=400)
    
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON format'}, status=400)
    
    coach_profile, created = Coach.objects.get_or_create(user=request.user)
    
    updated_fields = []
    
    #? Update coach profile fields
    if 'full_name' in data and data['full_name']:
        coach_profile.full_name = data['full_name']
        updated_fields.append('full_name')
    
    if 'expertise' in data and data['expertise']:
        coach_profile.expertise = data['expertise']
        updated_fields.append('expertise')
    
    if 'experience_years' in data:
        try:
            experience_years = int(data['experience_years'])
            if experience_years < 0:
                return JsonResponse({'error': 'Experience years cannot be negative'}, status=400)
            coach_profile.experience_years = experience_years
            updated_fields.append('experience_years')
        except ValueError:
            return JsonResponse({'error': 'Experience years must be a number'}, status=400)
    
    if 'rating' in data:
        try:
            rating = float(data['rating'])
            if 0 <= rating <= 5:
                coach_profile.rating = rating
                updated_fields.append('rating')
            else:
                return JsonResponse({'error': 'Rating must be between 0 and 5'}, status=400)
        except ValueError:
            return JsonResponse({'error': 'Rating must be a number'}, status=400)
    
    coach_profile.save()
    
    is_complete = bool(
        coach_profile.full_name and 
        coach_profile.expertise and 
        coach_profile.experience_years > 0
    )
    
    response_data = {
        'message': 'Coach profile saved successfully' if not created else 'Coach profile created successfully',
        'profile': {
            'full_name': coach_profile.full_name,
            'expertise': coach_profile.expertise,
            'experience_years': coach_profile.experience_years,
            'rating': float(coach_profile.rating),
            'sessions_count': coach_profile.sessions_count,
            'is_complete': is_complete
        },
        'updated_fields': updated_fields
    }

    if is_complete and request.method != 'GET':
        response_data['profile_complete'] = True
        response_data['next_endpoint'] = '/api/coach/dashboard/'
    
    return JsonResponse(response_data, status=200)   


@csrf_exempt
@require_http_methods(["GET"])
def get_client_profile(request):
    """
    GET - get all the client credentials
    """
    
    if not request.user.is_authenticated:
        return JsonResponse({'error': 'Authentication required'}, status=401)
    
    #? Check if user is a client
    if request.user.user_type != 'client':
        return JsonResponse({'error': 'User is not a client'}, status=400)
    
    #? Get profile
    if hasattr(request.user, 'client_profile'):
        profile = request.user.client_profile
        
        is_complete = bool(profile.full_name and profile.phone)
        
        return JsonResponse({
            'profile': {
                'full_name': profile.full_name,
                'phone': profile.phone,
                'bio': profile.bio,
                'location': profile.location,
                'avatar': str(profile.avatar) if profile.avatar else None,
                'is_complete': is_complete,
                'created_at': profile.user.created_at.isoformat() if hasattr(profile.user, 'created_at') else None
            }
        }, status=200)
    else:
        return JsonResponse({
            'error': 'Profile not found',
            'requires_creation': True
        }, status=404)
    


@csrf_exempt
@require_http_methods(["GET"])
def get_coach_profile(request):
    """
    GET - get all the coach credentials
    """
    if not request.user.is_authenticated:
        return JsonResponse({'error': 'Authentication required'}, status=401)
    
    #? Check if user is a coach
    if request.user.user_type != 'coach':
        return JsonResponse({'error': 'User is not a coach'}, status=400)
    
    #? Get profile
    if hasattr(request.user, 'coach_profile'):
        profile = request.user.coach_profile
        
        is_complete = bool(
            profile.full_name and 
            profile.expertise and 
            profile.experience_years > 0
        )
        
        return JsonResponse({
            'profile': {
                'full_name': profile.full_name,
                'expertise': profile.expertise,
                'experience_years': profile.experience_years,
                'rating': float(profile.rating),
                'sessions_count': profile.sessions_count,
                'is_complete': is_complete,
                'created_at': profile.user.created_at.isoformat() if hasattr(profile.user, 'created_at') else None
            }
        }, status=200)
    else:
        return JsonResponse({
            'error': 'Profile not found',
            'requires_creation': True
        }, status=404)
    

@csrf_exempt
@require_http_methods(["GET"])
def list_coaches(request):
    """GET - List all coaches so wze can display it for the clients"""
    coaches = Coach.objects.all()
    
    data = []
    for coach in coaches:
        data.append({
            'id': coach.id,
            'username': coach.user.username,
            'full_name': coach.full_name,
            'expertise': coach.expertise,
            'experience_years': coach.experience_years,
            'rating': float(coach.rating)
        })
    

    return JsonResponse({'coaches': data}, status=200)


@csrf_exempt
@require_http_methods(["GET"])
def get_coach_by_id(request, coach_id):
    #? GET if the client click on a coach profile we need to display all the informations
    try:
        coach = Coach.objects.get(id=coach_id)
    except Coach.DoesNotExist:
        return JsonResponse({'error': 'Coach not found'}, status=404)
    
    data = {
        'id': coach.id,
        'username': coach.user.username,
        'full_name': coach.full_name,
        'expertise': coach.expertise,
        'experience_years': coach.experience_years,
        'rating': float(coach.rating),
        'sessions_count': coach.sessions_count
    }
    
    return JsonResponse(data, status=200)


@csrf_exempt
@login_required
@require_http_methods(["POST"])
def create_offer(request):
    #? POST  coach crete an offer to display to client he need to fill all the required filds
    user = request.user
    
    if user.user_type != 'coach':
        return JsonResponse({'error': 'Only coaches can create offers'}, status=403)
    
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)
    #! validation of required fields if something is missing it will raise an error
    required_fields = ['name', 'price', 'duration']
    missing_fields = [f for f in required_fields if f not in data]
    if missing_fields:
        return JsonResponse({'error': f'Missing fields: {missing_fields}'}, status=400)
    
    coach = user.coach_profile
    
    offer = Offer.objects.create(
        coach=coach,
        name=data['name'],
        description=data.get('description', ''),
        price=data['price'],
        duration=data['duration'],
        availability=data.get('availability', True)
    )
    
    return JsonResponse({
        'message': 'Offer created successfully',
        'offer': {
            'id': offer.id,
            'name': offer.name,
            'description': offer.description,
            'price': float(offer.price),
            'duration': offer.duration,
            'availability': offer.availability
        }
    }, status=201)

@csrf_exempt
@require_http_methods(["GET"])
def coach_offers(request, coach_id):
    #? GET List of all offers for a specific coach
    try:
        coach = Coach.objects.get(id=coach_id)
    except Coach.DoesNotExist:
        return JsonResponse({'error': 'Coach not found'}, status=404)
    
    offers = Offer.objects.filter(coach=coach, availability=True)
    
    data = []
    for offer in offers:
        data.append({
            'id': offer.id,
            'name': offer.name,
            'description': offer.description,
            'price': float(offer.price),
            'duration': offer.duration,
            'availability': offer.availability
        })
    
    return JsonResponse({'offers': data}, status=200)



@csrf_exempt
@login_required
@require_http_methods(["POST"])
def book_session(request, coach_id):
    #? POST the coach reponse to the session booked by the client
    """
    postman body example:
    {
    "session_date": "22-04-2026",
    "start": "14:00:00",
    "end": "15:00:00"
    }
    """
    user = request.user
    
    if user.user_type != 'client':
        return JsonResponse({'error': 'Only clients can book sessions'}, status=403)
    
    try:
        coach = User.objects.get(id=coach_id, user_type='coach')
    except User.DoesNotExist:
        return JsonResponse({'error': 'Coach not found'}, status=404)
    
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)
    
    required_fields = ['session_date', 'start', 'end']
    missing = [f for f in required_fields if f not in data]
    if missing:
        return JsonResponse({'error': f'Missing fields: {missing}'}, status=400)
    
    session = Session.objects.create(
        client=user,
        coach=coach,
        session_date=data['session_date'],
        start=data['start'],
        end=data['end'],
        status='pending',
        price=None
    )
    
    return JsonResponse({
        'message': 'Session booked successfully',
        'session': {
            'session_id': session.id,
            'coach_name': session.coach.username,
            'date': session.session_date,
            'start': session.start,
            'end': session.end,
            'status': session.status,
            'price': session.price
        }
    }, status=201)

@csrf_exempt
@login_required
@require_http_methods(["GET"])
def coach_sessions(request):
    #? GET Coach views all their sessions requested by the clients
    user = request.user
    
    if user.user_type != 'coach':
        return JsonResponse({'error': 'Only coaches can view sessions'}, status=403)
    
    sessions = Session.objects.filter(coach=user)
    
    data = []
    for session in sessions:
        data.append({
            'session_id': session.id,
            'client_name': session.client.username,
            'date': session.session_date,
            'start': session.start,
            'end': session.end,
            'status': session.status,
            'price': float(session.price) if session.price else None
        })
    
    return JsonResponse({'sessions': data}, status=200)

@csrf_exempt
@login_required
@require_http_methods(["GET"])
def session_detail(request, session_id):
    #? GET Get session details by ID
    user = request.user
    
    try:
        session = Session.objects.get(id=session_id)
    except Session.DoesNotExist:
        return JsonResponse({'error': 'Session not found'}, status=404)
    
    # Check if user is client or coach in this session
    if session.client != user and session.coach != user:
        return JsonResponse({'error': 'You are not authorized to view this session'}, status=403)
    
    return JsonResponse({
        'session': {
            'session_id': session.id,
            'client_name': session.client.username,
            'coach_name': session.coach.username,
            'date': session.session_date,
            'start': session.start,
            'end': session.end,
            'status': session.status,
            'price': float(session.price) if session.price else None
        }
    }, status=200)

@csrf_exempt
@login_required
@require_http_methods(["PATCH"])
def update_session(request, session_id):
    #? PATCH  Coach updates session status and price by either confirmed or rejected and the price
    user = request.user
    
    if user.user_type != 'coach':
        return JsonResponse({'error': 'Only coaches can update sessions'}, status=403)
    
    try:
        session = Session.objects.get(id=session_id, coach=user)
    except Session.DoesNotExist:
        return JsonResponse({'error': 'Session not found'}, status=404)
    
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)
    
    if 'status' in data:
        session.status = data['status']
    
    if 'price' in data:
        session.price = data['price']
    
    session.save()
    
    return JsonResponse({
        'message': f'Session {session.status}',
        'session': {
            'session_id': session.id,
            'client_name': session.client.username,
            'date': session.session_date,
            'start': session.start,
            'end': session.end,
            'status': session.status,
            'price': float(session.price) if session.price else None
        }
    }, status=200)