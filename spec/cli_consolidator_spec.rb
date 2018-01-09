require 'spec_helper'
require 'proptax/cli'

describe Proptax::CLI, :type => :aruba do
    
  before :each do
  end

  describe 'consolidator' do
    it "doesn't barf if directory provided doesn't exist" do
      run_simple "proptax consolidate fake_dir"
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output /Directory fake_dir does not exist/
    end 

    it "produces the correct output when provided a valid directory" do
      FileUtils.cp_r 'spec/aruba_data', 'tmp/aruba/aruba_data'
      # `#read` leaves a `\n`, while `aruba` does not
      expected = File.read('spec/aruba_data/expected_consolidated.csv').strip
    
      run_simple "proptax consolidate aruba_data"
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output expected
    end
  end
end

