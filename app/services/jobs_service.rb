class JobsService
  include HTTParty
  attr_reader :page, :per

  API_PATH="http://142.93.246.163/api/v1"
  DEFAULT_PER_PAGE=50

  def initialize(page: 1, per: DEFAULT_PER_PAGE)
    @page = page
    @per = per
  end

  def actual_links
    self.class.get(API_PATH + "/jobs/actual-links", pagination_query)["data"]
  end

  private 
    def pagination_query
      { query: { page: page, per: per } }
    end
end