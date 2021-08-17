RSpec.describe 'Traffic Light Controller' do  
  include CommandHelpers
  include StatusHelpers

  describe "Detector Logic" do
    describe 'list' do
      # Verify status S0016 number of detector logics
      #
      # 1. Given the site is connected
      # 2. Request status
      # 3. Expect status response before timeout
      specify 'size is read with S0016', sxl: '>=1.0.7' do |example|
        request_status_and_confirm "number of detector logics",
          { S0016: [:number] }
      end
    end

    describe 'status' do
      # Verify status S0002 detector logic status
      #
      # 1. Given the site is connected
      # 2. Request status
      # 3. Expect status response before timeout
      it 'is read with S0002', sxl: '>=1.0.7' do |example|
        request_status_and_confirm "detector logic status",
          { S0002: [:detectorlogicstatus] }
      end
    end

    context 'forcing' do
      # Verify status S0021 manually set detector logic
      #
      # 1. Given the site is connected
      # 2. Request status
      # 3. Expect status response before timeout
      it 'is read with S0021', sxl: '>=1.0.7' do |example|
        request_status_and_confirm "manually set detector logics",
          { S0021: [:detectorlogics] }
      end

      # 1. Verify connection
      # 2. Send control command to switch detector_logic= true
      # 3. Wait for status = true
      it 'is set with M0008', sxl: '>=1.0.7' do |example|
        Validator::Site.connected do |task,supervisor,site|
          prepare task, site
          switch_detector_logic
        end
      end
    end

    describe 'trigger level sensitivity' do
      # Verify status S0031 trigger level sensitivity for loop detector
      #
      # 1. Given the site is connected
      # 2. Request status
      # 3. Expect status response before timeout
      it 'is set with S0031', sxl: '>=1.0.15' do |example|
        request_status_and_confirm "loop detector sensitivity",
          { S0031: [:status] }
      end
    end
  end
end