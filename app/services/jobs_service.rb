class JobsService
  include HTTParty
  attr_reader :page, :per

  API_PATH="http://142.93.246.163/api/v1"
  DEFAULT_PER_PAGE=50

  def initialize(page: 1, per: DEFAULT_PER_PAGE)
    @page = page
    @per = per
  end

  def actual_links_request
    @actual_links_request ||= self.class.get(API_PATH + "/jobs/actual-db", pagination_query)
  end

  def jobs
    actual_links_request["data"]
  end 

  def jobs_page_count
    actual_links_request["total_pages"]
  end 

  def total_jobs_count
    jobs_page_count.to_i * DEFAULT_PER_PAGE
  end 

  private 
    def pagination_query
      { query: { page: page, per: per } }
    end
end