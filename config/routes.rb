Rails.application.routes.draw do
  devise_for :users
  root 'users#index'  # ログインor新規登録を選ぶページ
  resources :users, only: :new  # 新規登録方法を選ぶページ
end
