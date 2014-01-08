class MicropostsController < ApplicationController
  # singed_in_user is defined in sessions_helper.rb
  # Notice the filter applies to all actions defined in this file,
  # the restriction ( only: [:action, :action]) does not have
  # to be specified.
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
  	@micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # Make an empty @feed_items instance variable when
      # micropost submission fails. 
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

    def micropost_params
      # Note the use of strong parameters via
      # micropost_params, which permits only the
      # micropost content to be edited through the web.
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end