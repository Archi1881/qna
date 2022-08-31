class SearchService
  RESOURCES = %w[All Question Answer Comment User].freeze

  def self.call(query, resource)
    RESOURCES.include?(resource)
    resource == 'All' ? ThinkingSphinx.search(query) : resource.constantize.search(query)
  end
end