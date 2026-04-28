"""
URL configuration for muscleup project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/6.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from myapp.views import *

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/register/', register, name='register'),
    path('api/login/', user_login, name='login'),
    path('api/logout/', user_logout, name='logout'),
    #path('api/client/dashboard/', client_dashboard, name='client_dashboard'),
    #path('api/coach/dashboard/', coach_dashboard, name='coach_dashboard'),
    path('api/client/profile/create/', client_profile, name='client_profile'),
    path('api/client/profile/', get_client_profile, name='get_client_profile'),
    path('api/coach/profile/', get_coach_profile, name='get_coach_profile'),
    path('api/coach/profile/create/', coach_profile, name='coach_profile'),
    path('api/allcoaches/', list_coaches, name='list_coaches'),
    path('api/coach/<int:coach_id>/', get_coach_by_id, name='get_coach_by_id'),
    path('api/coach/create_offer/', create_offer, name='create_offer'),
    path('api/coach/offers/<int:coach_id>/', coach_offers, name='coach_offers'),
    path('api/client/coach/<int:coach_id>/session/', book_session, name='book_session'),
    path('api/coach/sessions/', coach_sessions, name='coach_sessions'),
    path('api/coach/sessions/<int:session_id>/', session_detail, name='session_detail'),
    path('api/sessions/<int:session_id>/update/', update_session, name='update_session'),
]