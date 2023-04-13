RSpec.describe 'Site::Traffic Light Controller' do  
  include Validator::CommandHelpers
  include Validator::StatusHelpers

  describe "System" do
    # Verify status S0091 operator logged in/out OP-panel
    #
    # 1. Given the site is connected
    # 2. Request status
    # 3. Expect status response before timeout
    specify 'operator logged in/out of OP-panel is read with S0091', sxl: '>=1.0.7' do |example|
      Validator::Site.connected do |task,supervisor,site|
        if RSMP::Proxy.version_meets_requirement?( site.sxl_version, '>=1.1' )
          status_list = { S0091: [:user] }
        else
          status_list = { S0091: [:user, :status] }
        end
        request_status_and_confirm site, "operator logged in/out OP-panel", status_list
      end
    end

    # Verify status S0092 operator logged in/out web-interface
    #
    # 1. Given the site is connected
    # 2. Request status
    # 3. Expect status response before timeout
    specify 'operator logged in/out of web-interface is read with S0092', sxl: '>=1.0.7' do |example|
      Validator::Site.connected do |task,supervisor,site|
        if RSMP::Proxy.version_meets_requirement?( site.sxl_version, '>=1.1' )
          status_list = { S0092: [:user] }
        else
          status_list = { S0092: [:user, :status] }
        end
        request_status_and_confirm site, "operator logged in/out web-interface", status_list
      end
    end

    # Verify status S0095 version of traffic controller
    #
    # 1. Given the site is connected
    # 2. Request status
    # 3. Expect status response before timeout
    specify 'version is read with S0095 ', sxl: '>=1.0.7' do |example|
      Validator::Site.connected do |task,supervisor,site|
        request_status_and_confirm site, "version of traffic controller",
        { S0095: [:status] }
      end
    end

    # 1. Verify connection i Isolated_mode
    # 2. Send the control command to restart, include security_code
    # 3. Wait for status response= stopped
    # 4. Reconnect as Isolated_mode
    # 5. Wait for status= ready
    # 6. Send command to switch to normal controll
    # 7. Wait for status "Yellow flash" = false, "Controller starting"= false, "Controller on"= true
    specify 'restart is triggered by M0004', sxl: '>=1.0.7' do |example|
      Validator::Site.isolated do |task,supervisor,site|
        prepare task, site
        supervisor.ignore_errors RSMP::DisconnectError do
          set_restart
          site.wait_for_state :disconnected, timeout: Validator.config['timeouts']['shutdown']
        end
      end

      # NOTE
      # when a remote site closes the connection, our site proxy object will stop.
      # when the site reconnects, a new site proxy object will be created.
      # this means we can't wait for the old site to become ready
      # it also means we need a new Validator::Site.
      Validator::Site.isolated do |task,supervisor,site|
        prepare task, site
        site.wait_for_state :ready, timeout: Validator.config['timeouts']['ready']
        wait_normal_control
      end
    end

    # 1. Verify connection
    # 2. Send control command to set securitycode_level
    # 3. Wait for status = true
    # 4. Send control command to setsecuritycode_level
    # 5. Wait for status = true
    specify 'security code is set with M0103', sxl: '>=1.0.7' do |example|
      Validator::Site.connected do |task,supervisor,site|
        prepare task, site
        set_security_code 1
        set_security_code 2
      end
    end

    specify 'security code is rejected when incorrect', sxl: '>=1.0.7' do |example|
      Validator::Site.connected do |task,supervisor,site|
        prepare task, site
        expect { wrong_security_code }.to raise_error(RSMP::MessageRejected)
      end
    end
  end
end
