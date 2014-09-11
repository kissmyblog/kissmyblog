# A proxy class to Image with some custom methods
class GHImage < GHFile
  attr_accessor :repository, :content

  def to_param
    name
  end

  def url
    File.join(@repository.config['url'], path)
  end

  def cdn_url
    File.join('https://rawgit.com/', repository.full_name, repository.last_commit.sha, path)
  end

  def update(attributes)
    tap do |i|
      # FIXME: Add a form of validation to preserve content_type
      i.content = attributes[:content].read
    end
  end

  def save
    repository.update_contents(path, "Upload new version of #{path}", sha, content)
  end
end