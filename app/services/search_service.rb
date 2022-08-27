class SearchService
  RESOURCES = %w[All Question Answer Comment User].freeze

  def self.call(query, resource)
    if RESOURCES.include?(resource)
      resource == 'All' ? ThinkingSphinx.search(query) : resource.constantize.search(query)
    else
      raise StandardError, 'Wrong resource! Select available resource.'
    end
  end
end