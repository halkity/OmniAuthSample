# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # SNS認証時に呼ばれるコールバック関数名が決まっている
  def facebook
    authorization
  end

  def google_oauth2
    authorization
  end

  def failure
    redirect_to root_path
  end

  private

  def authorization
    # APIから受け取ったレスポンスがrequest.env["omniauth.auth"]という変数に入る
    # DB操作を行うメソッドUser.from_omniauthを仮で作り、変数を渡す。
    sns_info = User.from_omniauth(request.env["omniauth.auth"])
    @user = sns_info[:user]

    # ＠userが保存済みで無い場合(新規登録する場合)、＠userという変数をそのまま新規登録のviewsで利用するためにrenderを使用する。
    if @user.persisted? #ユーザー情報が登録済みなので、新規登録ではなくログイン処理を行う
      sign_in_and_redirect @user, event: :authentication
    else #ユーザー情報が未登録なので、新規登録画面へ遷移する
      render template: 'devise/registrations/new'
    end
  end
end
