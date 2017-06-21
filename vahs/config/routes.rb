Rails.application.routes.draw do
  get '/', to: 'base#index'
  get '/index', to: 'base#index'
  root "base#index"

  get 'docket', to: 'docket#get'
  post 'docket', to: 'docket#post'

  get 'analysis', to: 'analysis#get'
  post 'analysis', to: 'analysis#post'

  get 'fiscalyears', to: 'docket#fiscalyears'
  post 'fiscalyears', to: 'docket#update_fiscalyears'

  namespace :rms, as: :rms do
    scope :employee, as: :employee do
      get '/', to: 'employee#index'

      get '/new', to: 'employee#new'
      post '/new', to: 'employee#new'

      get '/edit/:id', to: 'employee#edit', as: :edit
      post '/edit/:id', to: 'employee#edit'

      get '/search', to: 'employee#search'
      post '/search', to: 'employee#search'

      get '/locator', to: 'employee#locator'
      post '/locator', to: 'employee#locator'

      get '/picture/(:id)', to: 'employee#picture'
    end

    scope :reports, as: :reports do
      get '/', to: 'reports#index'

      get '/pipeline', to: 'reports#pipeline'
      get '/snapshot', to: 'reports#snapshot'
      get '/fte', to: 'reports#fte'
      get '/paid_exception', to: 'reports#paid_exception'
    end
  end

  scope :admin do
    get '/roles', to: 'admin#roles', as: :admin_roles
  end

  get 'contact_us', to: 'base#contact_us'
  get 'resource_guide', to: 'base#resource_guide'
end
