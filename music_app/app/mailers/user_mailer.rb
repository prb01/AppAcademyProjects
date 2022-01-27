class UserMailer < ApplicationMailer
  default from: 'welcome@musicapp.com'

  def activation_email(user)
    @user = user
    @url = "#{activate_users_url}?activation_token=#{@user.activation_token}"

    mail(to: user.email, subject: "Please confirm your email address")
  end
end
