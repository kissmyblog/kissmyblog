# A proxy class to Posts with some custom methods
class GHDraft < GHPost
  def draft?
    true
  end
end