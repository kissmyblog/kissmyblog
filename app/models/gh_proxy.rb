# A proxy class
class GHProxy
  extend ActiveModel::Naming

  def initialize(target = nil)
    @target = target
  end

  def persisted?
    true
  end

  class << self
    def model_name
      ActiveModel::Name.new(self, nil, name.gsub(/^GH/, ''))
    end
  end

  def method_missing(method, *args, &block)
    @target.send(method, *args, &block)
  end
end