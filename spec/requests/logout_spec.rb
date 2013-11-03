require 'spec_helper'

describe "Logout", js: true do

  before(:each) do
    user = FactoryGirl.create(:user)
    visit '/users/sign-in'

    within('#login-form') do
      fill_in 'email', :with => user.email
      fill_in 'password', :with => user.password
    end

    click_button 'Login'
  end

  it "render login form when clicked on logout link" do
    click_button "show_menu_button"
    click_link 'link-sign-out'
    assert page.has_selector?('div#headerCarousel')
  end

end

