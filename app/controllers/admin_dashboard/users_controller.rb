class AdminDashboard::UsersController < AdminDashboard::BaseController
  helper :hot_glue
  include HotGlue::ControllerHelper

  
  
  before_action :load_user, only: [:show, :edit, :update, :destroy]
  after_action -> { flash.discard }, if: -> { request.format.symbol ==  :turbo_stream }

   

  def load_user
    @user = User.find(params[:id])
  end
  

  def load_all_users
    
    @users = User.page(params[:page])
    
  end

  def index
    load_all_users
    respond_to do |format|
       format.html
    end
  end

  def new
    
    @user = User.new()
   
    respond_to do |format|
      format.html
    end
  end

  def create
    modified_params = modify_date_inputs_on_params(user_params.dup )
    @user = User.create(modified_params)

    if @user.save
      flash[:notice] = "Successfully created #{@user.name}"
      load_all_users
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to admin_dashboard_users_path }
      end
    else
      flash[:alert] = "Oops, your user could not be created."
      respond_to do |format|
        format.turbo_stream
        format.html
      end
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

    if @user.update(modify_date_inputs_on_params(user_params))
      flash[:notice] = (flash[:notice] || "") << "Saved #{@user.name}"
    else
      flash[:alert] = (flash[:alert] || "") << "User could not be saved."

    end

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def destroy
    begin
      @user.destroy
    rescue StandardError => e
      flash[:alert] = "User could not be deleted"
    end
    load_all_users
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to admin_dashboard_users_path }
    end
  end

  def user_params
    params.require(:user).permit( [:email, :name] )
  end

  def default_colspan
    2
  end

  def namespace
    "admin_dashboard/" 
  end
end


