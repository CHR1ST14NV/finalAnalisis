from django.urls import path
from .views import RegisterView, RoleListView, MeView

urlpatterns = [
    # Support both with and without trailing slashes for compatibility
    path('register', RegisterView.as_view(), name='register'),
    path('register/', RegisterView.as_view()),
    path('roles', RoleListView.as_view(), name='roles'),
    path('roles/', RoleListView.as_view()),
    path('me', MeView.as_view(), name='me'),
    path('me/', MeView.as_view()),
]
