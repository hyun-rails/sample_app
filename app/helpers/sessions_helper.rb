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

    def current_user?(user)
        user == current_user
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

    # redirect_back_or and store_location are methods for 
    # friendly forwarding. The "session" is
    # a facility provided by Rails.  
    def redirect_back_or(default)
        # evaluates to session[:return_to] unless it's nil, in which
        # case it evaluates to the given default URL
        redirect_to(session[:return_to] || default)
        session.delete(:return_to)
    end

    def store_location
        session[:return_to] = request.url if request.get?
    end
end
