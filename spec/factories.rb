FactoryGirl.define do

  factory :user do
    name 'Farma user'
    sequence(:email) {|n| "person-#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
    admin false
  end

  factory :lo do
    user
    sequence(:name) {|n| "learner object-#{n}" }
    description "Describe the objective of the lo"
    available true
  end

  factory :exercise do
    lo
    title "Exercise"
    content "Exercise enunciation"
    available true
    sequence(:position) {|n| n }
  end

  factory :question do
    exercise
    title "Question"
    content "Question enunciation"
    correct_answer "x + 1"
    available true
    sequence(:position) {|n| n }
  end

  factory :team do
    sequence(:name) {|n| "Team-#{n}" }
    code "1234"
    #owner_id must be defined in runtime
  end

  factory :answer do
    response    "x"
    for_test    false
    #team_id     team.id      - must be defined in runtime
    #lo_id       lo.id        - must be defined in runtime
    #exercise_id exercise.id  - must be defined in runtime
    #question_id question.id  - must be defined in runtime
    user
  end
end
