Rails.application.routes.draw do
#root 'posts#index' ログインしていないと表示されないページ
root 'users#login_form'

  get 'users/index'
  get 'signup' => 'users#new'
  post 'users/create' => 'users#create'
  get 'users/:id/edit' => 'users#edit'
  post 'users/:id/update' => 'users#update'

  get 'login' => 'users#login_form'
  post 'login' => 'users#login'
  post 'logout' => 'users#logout'

  post 'likes/:post_id/create' => 'likes#create'
  post 'likes/:post_id/destroy' => 'likes#destroy'
  get 'users/:id/likes' => 'users#likes'

  get 'posts/index' => 'posts#index'

  #投稿検索機能のルーティング
  get 'posts/search' => 'posts#search'
  
  #コメント機能
  resources :posts do
    resources :comments, only:[:create, :destroy]
  end

  #フォローフォロワー機能
  resources :users, only:[:index, :show, :edit, :update] do
    member do
      get :follows, :followers
    end
    resource :relationships, only: [:create, :destroy]
  end


  get 'users/:id' => 'users#show'

  get 'posts/index' => 'posts#index'
  get 'posts/new' => 'posts#new'
  post 'posts/create' => 'posts#create'
  get 'posts/:id/edit' => 'posts#edit'
  post 'posts/:id/update' => 'posts#update'
  post 'posts/:id/destroy' => 'posts#destroy'
  #投稿検索機能のルーティング
  get 'posts/search' => 'posts#search'


  get 'posts/:id' => 'posts#show'
  get '/' => 'home#top'

  get 'about' => 'home#about'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
