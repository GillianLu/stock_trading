class AdminMailer < ApplicationMailer
    default from: 'notification@example.com'
    
    def trader_approval_email(user)
        @user = user
        mail(to: @user.email, subject: 'Your trader approval')
    end
      
    def admin_role_email(user)
        @user = user
        mail(to: @user.email, subject: 'Congratulations on becoming an admin!')
    end
end