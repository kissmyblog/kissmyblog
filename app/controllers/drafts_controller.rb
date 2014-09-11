class DraftsController < PostsController
  private
    def set_post
      @post = @repository.get_draft(params[:id])
    end
end
