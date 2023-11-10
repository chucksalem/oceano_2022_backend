# frozen_string_literal: true

# Create an admin user.
# Currently there isn't anything super secret behind the auth wall, so I figured
# it would be safe to commit the admin user credentials.
User.create(
  email: 'chuck@chucksalem.com',
  password: '3ka55up5m48u',
  password_confirmation: '3ka55up5m48u',
  role: 'admin'
)
