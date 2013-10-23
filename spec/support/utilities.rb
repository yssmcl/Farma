def sign_in(user, options={})
  visit '/users/sign-in'
  fill_in "email",    with: user.email
  fill_in "password", with: user.password
  click_button "Login"
end
