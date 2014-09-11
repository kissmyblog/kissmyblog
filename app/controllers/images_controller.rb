class ImagesController < ApplicationController
  before_action :set_repository
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  def index
    @images = @repository.images
  end

  def show
  end

  def new
    @image = Image.new(repository: @repository)
  end

  def edit
  end

  def create
    @image = Image.new(image_params)
    # send_data @image.content, filename: @image.name, type: @image.content_type, disposition: 'inline'
    if @image.save
      redirect_to repository_image_path(@repository, @image), notice: 'Image was successfully uploaded.'
    else
      render :new
    end
  end

  def update
    @image.update(image_params)
    if @image.save
      redirect_to repository_image_path(@repository, @image), notice: 'Image was successfully uploaded.'
    else
      render :edit
    end
  end

  def destroy
    @image.destroy
    redirect_to repository_images_path(@repository.id), notice: 'Image was successfully deleted.'
  end

  private
    def set_repository
      @repository = GHRepository.new(client, client.repository(params[:repository_id].to_i))
    end

    def set_image
      @image = @repository.get_image(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params[:image].permit(:content).merge(repository: @repository)
    end
end
