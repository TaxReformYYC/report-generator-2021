require 'spec_helper'
require 'proptax/cli'

describe Proptax::CLI, :type => :aruba do
    
  before :each do
    FileUtils.cp_r 'spec/aruba_data', 'tmp/aruba/aruba_data'
  end

  describe 'filter' do
    it "takes a file as input and calculates precise discrepencies" do
      expected = File.read('spec/aruba_data/expected_filtered.txt')

      run_simple 'proptax filter aruba_data/consolidated_for_filter.csv'
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started.output).to eq expected
    end 

    describe 'csv options' do
      it "takes a file as input and outputs discrepencies in CSV format" do
        expected = File.read('spec/aruba_data/expected_filtered.csv')

        run_simple 'proptax filter aruba_data/consolidated_for_filter.csv --csv'
        expect(last_command_started).to be_successfully_executed
        expect(last_command_started.output).to eq expected
      end 

      it "does not output header string if specified" do
        run_simple 'proptax filter aruba_data/consolidated_for_filter.csv --csv --no-header'
        expect(last_command_started).to be_successfully_executed
        expect(last_command_started.output).not_to include "houseNumbers,assessedValues,adjustedValues,assessedDifferences,discrepancies"
      end
    end
  end
end
