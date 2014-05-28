Carrie::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  scope "api" do
    namespace :published do
      resources :los, only: :show
      match '/teams/:team_id/los/:id' => "los#show"
    end

    match '/home/lo_example' => "home#lo_example"
    match '/home/dashboard' => "home#dashboard"

    match 'requests/los/to-me' => "request_los#to_me", via: :get
    match '/requests/:lo_id', to: 'request_los#petition', via: :post
    match '/requests/:id/authorize' => "request_los#authorize", via: :post
    match '/requests/:id/not-authorize' => "request_los#not_authorize", via: :post

    match '/lo-contents/:id' => "lo_contents#index", via: :get
    match '/lo-contents/:id/sort' => "lo_contents#sort", via: :post

    # Reports filters
    match '/reports/my-created-teams' => "reports#current_user_created_teams", via: :get
    match '/reports/teams/:team_id/los' => "reports#los_from_team", via: :get
    match '/reports/teams/:team_id/learners-and-los' => "reports#learners_and_los_from_team", via: :get

    # My learners progress
    match '/reports/progress/teams/:team_id/los/:lo_id' => "reports#learners_progress", via: :get
    match '/reports/teams/:team_id/los/:lo_id/timeline/:user_id' => "reports#timeline", via: :get

    # Report from a user
    match '/reports/teams/:team_id/los/:lo_id/learners/:learner_id' => "reports#learner_report", via: :get

    # Current user progress
    match '/reports/my-teams-los' => "reports#current_user_teams_los", via: :get
    match '/reports/my-timeline/teams/:team_id/los/:lo_id' => "reports#my_timeline", via: :get

    # Exercises sequence
    namespace :sequence do
      match '/teams/:team_id/los/:lo_id' => "sequence#calculates", via: :post
    end

    resources :retroaction_answers, only: :create
    resources :contacts, only: :create

    resources :answers do
      get 'retroaction', on: :member
      get 'page/:page', :action => :index, :on => :collection

      get 'my', :action => :search_in_my, :on => :collection
      get 'my/page/:page', :action => :search_in_my, :on => :collection

      get 'teams-enrolled', action: :search_in_teams_enrolled, :on => :collection
      get 'teams-enrolled/page/:page', action: :search_in_teams_enrolled, :on => :collection

      get 'teams-created', :action => :search_in_teams_created, :on => :collection
      get 'teams-created/page/:page', :action => :search_in_teams_created, :on => :collection

      get 'for-question/:question_id', :action => :for_question, :on => :collection
      get 'for-question/:question_id/page/:page', :action => :for_question, :on => :collection
      resources :comments
    end

    resources :teams do
      get 'created', on: :collection
      get 'enrolled', on: :collection
      get 'my_teams', on: :collection
      get 'los', on: :collection
      get 'learners', on: :collection
      post 'enroll', on: :member
      get 'page/:page', :action => :index, :on => :collection
    end

    resources :los do
      get 'my_los', on: :collection
      get 'shared', on: :collection
      get 'shared/page/:page', :action => :shared, :on => :collection
      get 'exercises', on: :collection
      resources :introductions
      resources :exercises do
        # Removed on 07/05/2014
        # Because its no long allowed a user clear your answers
        # delete 'delete_last_answers', :on => :member
        resources :questions do
          resources :tips
          collection {post :sort}
        end
      end
    end
  end

  constraints lambda {|req| req.url =~ /api\/users/ && req.delete? ? false : true} do
    devise_for :users
  end

  root to: "home#index"
  match '*path', to: 'home#index'
end
