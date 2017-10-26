Rails.application.routes.draw do

  resources :users
  resources :classrooms do
    get '/members', to: 'classrooms#members', as: :members
    get '/logs', to: 'logs#teacher_index', as: :logs
    resources :sections, :except => [:index, :show]
    resources :links, :except => [:index, :show]
    resources :documents, :except => [:index, :show]
    resources :surveys, :except => [:index] do
      post '/answer', to: 'surveys#answer', as: :answer
    end
    resources :tests, :except => [:index] do
      post '/solve', to: 'tests#solve', as: :solve
      get '/evaluate/:user_id', to: 'tests#evaluation', as: :evaluation
      post '/evaluate/:user_id', to: 'tests#evaluate', as: :evaluate
    end
    resources :assignments, :except => [:index] do
      post '/submit', to: 'assignments#submit', as: :submit
      get '/evaluate/:user_id', to: 'assignments#evaluation', as: :evaluation
      post '/evaluate/:user_id', to: 'assignments#evaluate', as: :evaluate
    end
  end

  root   'pages#home'
  get    '/logs', to: 'logs#admin_index', as: :logs
  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  get    '/activate/:token', to: 'users#activate', as: :activate
  get    '/login',   to: 'users#login'
  post   '/login',   to: 'users#user_login'
  delete '/logout',  to: 'users#logout'
  get    '/password-reset', to: 'users#password_reset', as: :password_reset
  post   '/password-reset', to: 'users#send_new_password'
  get    '/password-reset/:token', to: 'users#choose_password', as: :choose_password
  patch  '/password-reset/:token', to: 'users#reset_password'
  get    '/subscribe/:id', to: 'subscriptions#new', as: :subscribe
  post   '/subscribe/:id', to: 'subscriptions#create'

end
