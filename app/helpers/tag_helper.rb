module TagHelper
  def canonical_href(host=canonical_host)
    raw "#{host}#{path_without_html_extension}#{trailing_slash_if_needed}#{whitelisted_query_string}"
  end
end
