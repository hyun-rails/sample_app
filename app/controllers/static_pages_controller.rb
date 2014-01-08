class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  	  # A micropost instance variable used in _micropost_form.html.erb
  	  @micropost = current_user.microposts.build if signed_in?
  	  # A feed instance variable
  	  @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end

end
