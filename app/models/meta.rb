# A proxy class to YAML fields with some custom methods
class Meta < GHProxy
  # Return the key or an empty hash
  def sub(key)
    Meta.new(@target.try(:[], key) || {})
  end
end