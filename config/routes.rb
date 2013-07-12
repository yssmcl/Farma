Carrie::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  scope "api" do
    namespace :published do
      resources :los, only: :show
      match '/teams/:team_id/los/:id' => "los#show"
    end

    resources :answers do
      get 'retroaction', on: :member
      get 'page/:page', :action => :index, :on => :collection

      get 'my', :action => :search_in_my, :on => :collection
      get 'my/page/:page', :action => :search_in_my, :on => :collection

      get 'search-in-teams-enrolled', action: :search_in_teams_enrolled, :on => :collection
      get 'search-in-teams-enrolled/page/:page', action: :search_in_teams_enrolled, :on => :collection

      get 'search-in-teams-created', :action => :search_in_teams_created, :on => :collection
      get 'search-in-teams-created/page/:page', :action => :search_in_teams_created, :on => :collection

      resources :comments
    end

    match '/home/lo_example' => "home#lo_example"
    resources :retroaction_answers, only: :create
    resources :contacts, only: :create

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
      get 'exercises', on: :collection
      resources :introductions do
        collection {post :sort}
      end
      resources :exercises do
        delete 'delete_last_answers', :on => :member
        resources :questions do
          resources :tips
          collection {post :sort}
        end
        collection { post :sort }
      end
    end
  end

  devise_for :users

  root to: "home#index"
  match '*path', to: 'home#index'
end
