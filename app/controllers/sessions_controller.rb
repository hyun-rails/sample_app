class SessionsController < ApplicationController
  #before_action :signed_in_user_filter, only: [:new, :create]
  
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		sign_in user # sign_in is defined in sessions_helper.rb
  		redirect_back_or user # redirect_back_or is defined in sessions_helper.rb
  	else
  		flash.now[:error] = 'Invalid email/password combination' 
  		render 'new'
  	end
  end

  def destroy
  	sign_out #This method is defined in /app/helpers/sessions_helper.rb
  	redirect_to root_url
  end	

  # Signed in users have no reason to access the new and 
  # create actions. Signed in users will be redirected to
  # the root URL if they do try to hit those pages
  def signed_in_user_filter
    if signed_in?
        redirect_to root_path, notice: "Already logged in"
    end
  end

end
