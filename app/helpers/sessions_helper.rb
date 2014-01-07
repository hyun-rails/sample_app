module SessionsHelper
	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
		self.current_user = user
	end

	def signed_in?
		!current_user.nil?
	end

    # This method defines self.current_user = user in sign_in function
	def current_user=(user)
		@current_user = user
	end

    def current_user
    	remember_token = User.encrypt(cookies[:remember_token])
    	@current_user ||= User.find_by(remember_token: remember_token)
    end

    def sign_out
    	# Change the user's remember token in the database
    	current_user.update_attribute(:remember_token,
                                  User.encrypt(User.new_remember_token))
    	# Delete the cookie
    	cookies.delete(:remember_token) 
    	
    	# Set the current user to nil
    	self.current_user = nil
    end
end
