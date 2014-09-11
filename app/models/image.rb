class Image
  include ActiveModel::Model
  attr_accessor :repository, :name, :path, :content, :content_type

  def initialize(attributes = nil)
    self.repository   = attributes[:repository]
    if attributes[:content]
      self.content      = attributes[:content].read
      self.content_type = attributes[:content].content_type
      self.name         = attributes[:content].original_filename
    end
  end

  def to_param
    name
  end

  def path
    File.join(repository.media_path, name)
  end

  #def mime_type
  #  MIME::Types.type_for(name).first.content_type
  #end

  def save
    repository.create_contents(path, "Upload #{path}", content)
  end
end