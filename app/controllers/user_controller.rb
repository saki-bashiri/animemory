class UserController < ApplicationController
  def mypage
    if params[:mp_user].present? && params[:mp_user].to_i > 0
      @mp_user = User.find_by_id(params[:mp_user].to_i)
    elsif @user.present?
      @mp_user = @user
    else
      redirect_to :controller => "anime", :action => "index"
      return
    end
    @comments = Comment.where("user_id = ?", @mp_user.id).includes(:anime)
  end

=begin
  def user_page
  end
=end

end


