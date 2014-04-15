FactoryGirl.define do

  factory :user do
    name 'Farma user'
    sequence(:email) {|n| "person-#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
    factory :admin do 
      admin true
    end
  end

  factory :lo do
    user
    sequence(:name) {|n| "learner object-#{n}" }
    description "Describe the objective of the lo"
    available true

    trait :with_introductions_and_exercises do
      after :create do |lo|
        FactoryGirl.create_list :introduction, 3, lo: lo
        FactoryGirl.create_list :exercise, 3, lo: lo
      end
    end
  end

  factory :introduction do
    lo
    title "Introduction "
    content "Exercise enunciation"
    available true
    sequence(:position) {|n| n }
  end

  factory :exercise do
    lo
    sequence(:title) { |n| "Exercise #{n}"}
    content "Exercise enunciation"
    available true
    sequence(:position) {|n| n }

    after :create do |exercise|
      FactoryGirl.create_list :question, 3, exercise: exercise
    end
  end

  factory :question do
    exercise
    sequence(:title) { |n| "Question #{n}"}
    content "Question enunciation"
    correct_answer "x + 1"
    available true
    sequence(:position) {|n| n }

    after :create do |question|
      (1..3).each do |n|
        FactoryGirl.create(:tip, question: question, number_of_tries: n)
      end
    end
  end

  factory :tip do
    question
    sequence(:number_of_tries) {|n| n + 3 } # plus 3 because question factory
    sequence(:content) {|n| "Tip #{n}"}
  end

  factory :team do
    sequence(:name) {|n| "Team-#{n}" }
    code "1234"
    #owner_id must be defined in runtime
  end

  # ====================================================== #
  # Answers Factories
  # ====================================================== #
  factory :soluction, class: Answers::Soluction do
    response    "x + 10"
    to_test    false
    user
  end

  factory :answers_tip, class: Answers::Tip do
    from_id { FactoryGirl.create(:tip).id }
    content { |n| "Dica #{n}" }
    number_of_tries { (1..5).to_a.sample }
  end

end
