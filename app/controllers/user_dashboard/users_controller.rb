class UserDashboard::UsersController < UserDashboard::BaseController
  helper :hot_glue
  include HotGlue::ControllerHelper

  before_action :authenticate_user!
  
  before_action :load_user, only: [:show, :edit, :update, :destroy]
  after_action -> { flash.discard }, if: -> { request.format.symbol ==  :turbo_stream }


  



  def load_user
    @user = current_user
  end

  def load_all_users
    
      
    @users = User.where(id: current_user.id) # returns iterable even though this user is anly allowed access to themselves
    
  end

  def index
    load_all_users
    respond_to do |format|
       format.html
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def update

    if @user.update(modify_date_inputs_on_params(user_params, current_user))
      flash[:notice] = (flash[:notice] || "") << "Saved #{@user.name}"
    else
      flash[:alert] = (flash[:alert] || "") << "User could not be saved."

    end

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end



  def user_params
    params.require(:user).permit( [:email, :name] )
  end

  def default_colspan
    2
  end

  def namespace
    "user_dashboard/" 
  end
end


