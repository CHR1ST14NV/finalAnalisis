"""Rutas de la UI CRUD (Grupo #6)."""
from django.urls import path
from .views import model_list_view, model_create_view, model_update_view, model_delete_view, ui_index


urlpatterns = [
    path('', ui_index, name='ui-index'),
    path('<str:app_label>/<str:model_name>/', model_list_view, name='ui-list'),
    path('<str:app_label>/<str:model_name>/new/', model_create_view, name='ui-create'),
    path('<str:app_label>/<str:model_name>/<int:pk>/edit/', model_update_view, name='ui-update'),
    path('<str:app_label>/<str:model_name>/<int:pk>/delete/', model_delete_view, name='ui-delete'),
]
