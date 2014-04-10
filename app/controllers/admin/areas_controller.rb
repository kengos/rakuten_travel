class Admin::AreasController < ::Admin::ApplicationController
  before_filter :load_resource, except: [:index, :new, :create]
  def index
    @areas = Area.order(enabled: :desc, id: :asc).page params[:page]
  end

  def new
    @area = Area.new
  end

  def create
    @area = Area.new(request_params)
    if @area.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @area.update(request_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @area.destroy
    redirect_to action: :index
  end

  def import_hotels
    jid = ImportHotelWorker.perform_async(@area.id)
    if jid.nil?
      flash[:error] = 'failed'
    else
      flash[:notice] = 'pushing into sidekiq' + jid.to_s
    end
    redirect_to action: :index
  end

  private

  def request_params
    params.require(:area).permit(:long_name, :short_name, :large, :middle, :small, :detail, :enabled)
  end

  def load_resource
    @area = Area.find(params[:id])
  rescue
    render_404
  end
end