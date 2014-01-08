class UsersController < ApplicationController

  # before_action command arrange for a particular method to be 
  # called before the given actions
  
  # Below two commands are called only before edit and update
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  # A before filter restricting the destroy action to admins
  before_action :admin_user,     only: :destroy
  # A before filter restricting signed in user from accessing
  # new or create action
  before_action :signed_in_user_filter, only: [:new, :create]

  # "index" action pulls the users out of the database, assigning
  # them to an @users instance variable for use in the view.
  # Notice it uses the "paginate" method.
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
    # The @microposts instance variable is used in 
    # app/views/users/show.html.erb
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params) 
    if @user.save
      sign_in @user # Sign in the user upon sign up
    	flash[:success] = "Welcome to the Sample App"
      redirect_to @user
    else
      render 'new'
    end
  end

  
  def edit
  end

  # Action to update the user based on the submitted params hash
  # With invalid information, the update attempt returns false, 
  # so the else branch re-renders the edit page.
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # "destroy" action. Finds the corresponding user and 
  # destroys it with the Active Record "destroy" method, and
  # then redirects to the user index
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private

    def user_params
      # Note that "admin" attribute is not in the list of permitted
      # attributes (.permit). This prevents arbitrary users
      # from granting themselves administrative access. 
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    # correct_user is called before edit and update. Notice how
    # @user = User.find(params[:id]) defines the user variable by
    # finding the user with id
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) # current_user? method is
                                                        # defined in SessionsHelpe
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
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
