class GistService
  def initialize(link, client: client_octokit)
    @link = link
    @client = client
    @gist = get_gist
  end

  def content
    @gist.files.map { |_, gist| [gist.filename, gist.content] }
  end

  private

  def client_octokit
    Octokit::Client.new
  end

  def hash_link
    @link.split('/').last
  end

  def get_gist
    @client.gist(hash_link)
  end
end
