class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: session_params[:email].downcase)

    if user && user.authenticate(session_params[:password])
      if user.activated?
        log_in user
        session_params[:remember_me] == '1' ? remember(user) : forget(user)
        # redirect_back_or(user)
      else
        message = "Account not activated. "
        message+= "Check your email for the activation link."
        flash[:warning] = message
      end
    else
      flash.now[:danger] = "Invalid email/password combination"
    end

    respond_to do |format|
      format.js
      format.html
    end


  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
  def session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end
end
