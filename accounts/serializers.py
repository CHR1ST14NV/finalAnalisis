from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import Role


class RoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Role
        fields = ['id', 'code', 'name']


class RegisterSerializer(serializers.Serializer):
    username = serializers.CharField(max_length=150)
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True, min_length=4)
    role_code = serializers.ChoiceField(choices=[(c, c) for c in Role.CODES])

    def create(self, validated_data):
        User = get_user_model()
        role = Role.objects.get(code=validated_data['role_code'])
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
        )
        user.roles.add(role)
        return user

