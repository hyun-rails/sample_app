class SessionsController < ApplicationController

  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		sign_in user #This method is defined in /app/helpers/sessions_helper.rb
  		redirect_to user
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
