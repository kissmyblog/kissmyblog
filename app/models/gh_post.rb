# A proxy class to Posts with some custom methods
class GHPost < GHFile
  attr_accessor :repository, :content, :data
  attr_reader :raw_data

  def to_param
    name
  end

  def read
    @content = decode_content
    if @content =~ /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
      @content  = $'
      @raw_data = $1
      @data     = SafeYAML.load(@raw_data)
    end
  end

  def draft?
    false
  end

  def full_content
    "#{data.to_yaml}---\n#{content}"
  end

  def update(attributes)
    # FIXME: Check if name changed to rename instead of update
    tap do |p|
      p.content = attributes[:content]
      p.data    = (SafeYAML.load(attributes[:raw_data]) || {}).merge(attributes[:data])
      p.repository.post_metadata.each do |meta|
        meta  = Meta.new(meta)
        field = meta.sub('field')
        if field['element'] == "checkbox"
          p.data[meta['name']] = p.data[meta['name']] == '1' ? true : false
        end
      end
    end
  end

  def save
    repository.update_contents(path, "Update #{path}", sha, full_content)
  end
end