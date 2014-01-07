class SessionsController < ApplicationController

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

end
