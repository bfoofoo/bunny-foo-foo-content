module Statistics
  class JobsStatistics < Statistics::BaseStatistic

    def job_counts_hash
      return @job_counts_hash if !@job_counts_hash.blank? 
      response = {}
      jobs.each do |job|
        response[job["title"]] = {
          job: job
          # total: filtered_users_by_affiliate(formsite, skip_converted: true, skip_duplicated: false).count,
          # submitted: filtered_users_by_affiliate(formsite).count,
          # total_converted: filtered_users_by_affiliate(formsite).select {|user| user.is_verified}.count,
          # failed_impressionwise: filtered_users_by_affiliate(formsite).select {|user| !user.is_impressionwise_test_success}.count,
          # failed_useragent: filtered_users_by_affiliate(formsite).select {|user| !user.is_useragent_valid}.count,
          # failed_dulpicate: filtered_users_by_affiliate(formsite, skip_duplicated: false).select {|user| user.is_duplicate}.count
        }
      end
      @job_counts_hash = response
      return @job_counts_hash
    end
  
    private
      def jobs
        @jobs ||= JobsService.new().actual_links
      end
  end
end



