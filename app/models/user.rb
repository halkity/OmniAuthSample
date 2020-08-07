class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  has_many :sns_credentials


  # SNS情報未登録
  # 新規登録→SNSの情報を取得し、併せてユーザー情報を登録
  # emailが合致するとき→ログインへ

  # SNS情報登録済み
  # そのままログインへ

  def self.from_omniauth(auth)  # authにはAPIから受け取ったレスポンスを代入
    sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_create
    
    # sns認証したことがあればアソシエーションで取得
    # 無ければemailでユーザー検索して取得orビルド(保存はしない)
    user = sns.user || User.where(email: auth.info.email).first_or_initialize(
      nickname: auth.info.name,
        email: auth.info.email
    )
    # userが登録済みの場合はそのままログインの処理へ行くので、ここでsnsのuser_idを更新しておく
    if user.persisted?
      sns.user = user
      sns.save
    end
    user
  end


end
  