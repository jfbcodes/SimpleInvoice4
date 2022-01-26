class UserDashboard::InvoicesController < UserDashboard::BaseController
  helper :hot_glue
  include HotGlue::ControllerHelper

  before_action :authenticate_user!
   
  before_action :user
    
  before_action :load_invoice, only: [:show, :edit, :update, :destroy]
  after_action -> { flash.discard }, if: -> { request.format.symbol ==  :turbo_stream }

  def user
    @user ||= current_user 
  end
  
     

  def load_invoice
    @invoice = user.invoices.find(params[:id])
  end
  

  def load_all_invoices
    
    @invoices = user.invoices.page(params[:page])
    
  end

  def index
    load_all_invoices
    respond_to do |format|
       format.html
    end
  end

  def new
    
    @invoice = Invoice.new(user: @user)
   
    respond_to do |format|
      format.html
    end
  end

  def create
    modified_params = modify_date_inputs_on_params(invoice_params.dup.merge!(user: @user ) , current_user)
    @invoice = Invoice.create(modified_params)

    if @invoice.save
      flash[:notice] = "Successfully created #{@invoice.number}"
      load_all_invoices
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to user_dashboard_user_invoices_path }
      end
    else
      flash[:alert] = "Oops, your invoice could not be created."
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

    if @invoice.update(modify_date_inputs_on_params(invoice_params, current_user))
      flash[:notice] = (flash[:notice] || "") << "Saved #{@invoice.number}"
    else
      flash[:alert] = (flash[:alert] || "") << "Invoice could not be saved."

    end

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def destroy
    begin
      @invoice.destroy
    rescue StandardError => e
      flash[:alert] = "Invoice could not be deleted"
    end
    load_all_invoices
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_dashboard_user_invoices_path }
    end
  end

  def invoice_params
    params.require(:invoice).permit( [:number] )
  end

  def default_colspan
    1
  end

  def namespace
    "user_dashboard/" 
  end
end


