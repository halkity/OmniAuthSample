Rails.application.routes.draw do
  devise_for :users, controllers: {
  omniauth_callbacks: 'users/omniauth_callbacks',
  registrations: 'users/registrations'
}
  root 'users#index'  # ログインor新規登録を選ぶページ
  resources :users, only: :new  # 新規登録方法を選ぶページ
end
