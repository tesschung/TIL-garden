from django.contrib.auth import get_user_model
from django.contrib.auth.forms import UserChangeForm, UserCreationForm


class CustomUserChangeForm(UserChangeForm):
    class Meta:
        model = get_user_model()  # return User
        fields = ('email', 'first_name', 'last_name')


class CustomUserCreationForm(UserCreationForm):
    class Meta(UserCreationForm.Meta):
        model = get_user_model()  # accounts.User
        fields = UserCreationForm.Meta.fields + ('email',)
