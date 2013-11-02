include Warden::Test::Helpers

def sign_in(user, options={})
  visit '/users/sign-in'
  fill_in "email",    with: user.email
  fill_in "password", with: user.password
  click_button "Login"
end

def login user = nil
  user = FactoryGirl.create(:user) unless user
  login_as user, scope: :user
  user
end
