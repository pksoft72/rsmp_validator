RSpec.describe "Traffic Light Controller" do
  include CommandHelpers

  describe "Aggregated Status" do
    # Verify that the controller responds to an aggregated status request.
    #
    # 1. Given the site is connected
    # 2. Request aggregated status 
    # 3. Expect aggregated status response before timeout
    it 'responds to aggregated status request', rsmp: '>=3.1.5' do |example|
      TestSite.connected do |task,supervisor,site|
        prepare task, site
        log_confirmation "request aggregated status" do
          site.request_aggregated_status TestSite.config['main_component'], collect: {
            timeout: TestSite.config['timeouts']['status_response']
          }
        end
      end
    end
  end
end
