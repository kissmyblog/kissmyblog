class PostsController < ApplicationController
  before_action :set_repository
  before_action :set_post, only: [:show, :edit, :update, :publish, :destroy]

  def index
    @posts = @repository.posts.reverse
    @drafts = @repository.drafts.reverse
  end

  def show
  end

  def new
    @post = Draft.new(repository: @repository)
  end

  def edit
  end

  def create
    @post = Draft.new(post_params)

    if @post.save
      redirect_to repository_draft_path(@repository, @post), notice: 'Draft was successfully created.'
    else
      render :new
    end
  end

  def update
    @post.update(post_params)
    if @post.save
      if @post.draft?
        redirect_to repository_draft_path(@repository, @post), notice: 'Draft was successfully updated.'
      else
        redirect_to repository_post_path(@repository, @post), notice: 'Post was successfully updated.'
      end
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to repository_posts_path(@repository.id), notice: "#{@post.draft? ? 'Draft': 'Post'} was successfully deleted."
  end

  def publish
    @post.publish
    redirect_to repository_post_path(@repository, @post), notice: 'Draft was successfully published.'
  end

  private
    def set_repository
      @repository = GHRepository.new(client, client.repository(params[:repository_id].to_i))
    end

    def set_post
      @post = @repository.get_post(params[:id])
    end

    def post_params
      data = params[:post][:data]
      params[:post].permit(:content, {data: data.keys}, :raw_data).merge(repository: @repository)
    end
end
