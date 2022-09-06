class UserMailer < ApplicationMailer
    default from: 'rohit.salitra07@gmail.com'
  
    def welcome_email
      @user = params[:user]
      @url  = 'http://example.com/login'
      mail(to: 'rathored2001@gmail.com', subject: 'Welcome to My Awesome Site')
    end
  end
  