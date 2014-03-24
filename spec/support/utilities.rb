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

def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    loop do
      active = page.evaluate_script('jQuery.active')
      break if active == 0
    end
  end
end

# Matchers
RSpec::Matchers.define :have_one do |association|
  match do |model|
    model = model.class
    model.reflect_on_all_associations(:has_one).find { |a| a.name == association }
  end
  failure_message_for_should do |model|
    "expected that #{model} have one #{association}"
  end
end

RSpec::Matchers.define :has_many do |association|
  match do |model|
    model = model.class
    model.reflect_on_all_associations(:has_many).find { |a| a.name == association }
  end
  failure_message_for_should do |model|
    "expected that #{model} has many #{association}"
  end
end

RSpec::Matchers.define :belongs_to do |association|
  match do |model|
    model = model.class
    model.reflect_on_all_associations(:belongs_to).find { |a| a.name == association }
  end
  failure_message_for_should do |model|
    "expected that #{model} belongs to #{association}"
  end
end

RSpec::Matchers.define :has_and_belongs_to_many do |association|
  match do |model|
    model = model.class
    model.reflect_on_all_associations(:has_and_belongs_to_many).find { |a| a.name == association }
  end
  failure_message_for_should do |model|
    "expected that #{model} has_and_belongs_to_many #{association}"
  end
end
