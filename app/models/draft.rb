class Draft
  include ActiveModel::Model
  attr_accessor :repository, :name, :path, :content, :data, :raw_data

  def to_param
    name
  end

  def name
    @name ||= date.strftime("%Y-%m-%d-#{title.parameterize}.markdown")
  end

  def path
    "_drafts/#{name}"
  end

  def title
    (data['title'] || '')
  end

  def title=(title)
    data['title'] = title
  end

  def date
    @date ||= Time.now
  end

  def data
    @data ||= {}
  end

  def raw_data
    @raw_data ||= "---\n"
  end

  def front_matter
    (SafeYAML.load(raw_data) || {}).merge(data).to_yaml
  end

  def full_content
    "#{front_matter}---\n#{content}"
  end

  def save
    repository.create_contents(path, "Create #{path}", full_content)
  end
end