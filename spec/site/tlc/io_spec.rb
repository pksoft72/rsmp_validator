RSpec.describe 'Traffic Light Controller' do  
  include CommandHelpers
  include StatusHelpers

  describe 'IO' do
    describe 'Input' do
      describe 'forcing' do
        # Verify status S0029 forced input status
        #
        # 1. Given the site is connected
        # 2. Request status
        # 3. Expect status response before timeout
        it 'is read with S0029', sxl: '>=1.0.13' do |example|
          request_status_and_confirm "forced input status",
            { S0029: [:status] }
        end

        # 1. Verify connection
        # 2. Send control command to set force input
        # 3. Wait for status = true  
        it 'is set with M0019', sxl: '>=1.0.13' do |example|
          Validator::Site.connected do |task,supervisor,site|
            status = 'False'
            input = 1
            inputValue = 'True'
            prepare task, site
            force_input status, input, inputValue
          end
        end    
      end

      # 1. Verify connection
      # 2. Verify that there is a Validator.config['validator'] with a input
      # 3. Send control command to switch input
      # 4. Wait for status "input" = requested  
      it 'is activated with M0006', sxl: '>=1.0.7' do |example|
        inputs = Validator.config['items']['inputs']
        skip("No inputs configured") if inputs.nil? || inputs.empty?
        Validator::Site.connected do |task,supervisor,site|
          prepare task, site
          inputs.each { |input| switch_input input }
        end
      end

      describe 'series' do
        # 1. Verify connection
        # 2. Send control command to set a serie of input
        # 3. Wait for status = true  
        it 'is activated with M0013', sxl: '>=1.0.8' do |example|
          Validator::Site.connected do |task,supervisor,site|
            status = "5,4134,65;511"
            prepare task, site
            set_series_of_inputs status
          end
        end
      end

      describe 'sensitivity' do
        # 1. Verify connection
        # 2. Send control command to set trigger level
        # 3. Wait for status = true  
        it 'is set with M0021', sxl: '>=1.0.15' do |example|
          Validator::Site.connected do |task,supervisor,site|
            status = 'False'
            output = 1
            outputValue = 'True'
            prepare task, site
            set_trigger_level status
          end
        end
      end
    end

    describe 'Output' do
      describe 'forcing' do
        # Verify status S0030 forced output status
        #
        # 1. Given the site is connected
        # 2. Request status
        # 3. Expect status response before timeout
        it 'is read with S0030', sxl: '>=1.0.15' do |example|
          request_status_and_confirm "forced output status",
            { S0030: [:status] }
        end

        # 1. Verify connection
        # 2. Send control command to set force ounput
        # 3. Wait for status = true
        it 'is set with M0020', sxl: '>=1.0.15' do |example|
          Validator::Site.connected do |task,supervisor,site|
            status = 'False'
            output = 1
            outputValue = 'True'
            prepare task, site
            force_output status, output, outputValue
          end
        end
      end
    end
  end
end