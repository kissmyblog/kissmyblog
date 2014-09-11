# A proxy class to Files hosted on Git with some custom methods
class GHFile < GHProxy
  attr_reader :content

  def initialize(target = nil, &block)
    super
    read
  end

  def read
    @content = decode_content
  end

  def decode_content
    Base64.decode64(@target.content).force_encoding('utf-8') if @target.content
  end

  def save
    repository.update_contents(path, "Update #{path}", sha, content)
  end

  def destroy
    repository.delete_content(path, "Delete #{path}", sha)
  end
end