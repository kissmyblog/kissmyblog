# A proxy class to Posts with some custom methods
class GHDraft < GHPost
  def draft?
    true
  end

  def publish
    new_path = path.gsub('_drafts', '_posts')
    repository.move_contents(path, new_path, "Publish #{path}")
  end
end
