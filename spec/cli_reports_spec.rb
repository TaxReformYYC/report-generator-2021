require 'spec_helper'
require 'proptax/cli'

describe Proptax::CLI, :type => :aruba do
    
  before :each do
    FileUtils.cp_r 'spec/aruba_data', 'tmp/aruba/aruba_data'
  end

  describe 'reports' do
    it "creates a `reports` directory" do
      expect(exist?('reports/')).to be false

      run_command_and_stop 'proptax reports aruba_data/'
      expect(last_command_started).to be_successfully_executed

      expect(exist?('reports/')).to be true
    end 

    it "creates markdown files for R and final typeset PDF" do
      run_command_and_stop 'proptax reports aruba_data/'
      expect(last_command_started).to be_successfully_executed

      expect(file?('reports/11363_ROCKYVALLEY_DR_NW.md')).to be true
      expect(file?('reports/11363_ROCKYVALLEY_DR_NW.pdf')).to be true
      expect(file?('reports/11363_ROCKYVALLEY_DR_NW.Rmd')).to be true
      expect(file?('reports/11367_ROCKYVALLEY_DR_NW.md')).to be true
      expect(file?('reports/11367_ROCKYVALLEY_DR_NW.pdf')).to be true
      expect(file?('reports/11367_ROCKYVALLEY_DR_NW.Rmd')).to be true
    end 

    it "writes the correct R markdown to the files" do
      run_command_and_stop 'proptax reports aruba_data/'

      expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11363 ROCKYVALLEY DR NW"/)
      expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 465000/)
      expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "aruba_data\/\/consolidated.csv"/)
      expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\),/)
      expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/limits=c\(min\(assessedValues\)-10000, max\(assessedValues\)\+10000\)\) \+/)

      expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11367 ROCKYVALLEY DR NW"/)
      expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 473000/)
      expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "aruba_data\/\/consolidated.csv"/)
      expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\),/)
      expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/limits=c\(min\(assessedValues\)-10000, max\(assessedValues\)\+10000\)\) \+/)
    end 

    #
    # Sometimes the plotted chart gets chopped off. `ylimit` can be set to provide more room for the plots
    #
    describe 'ylimit option' do
      it "creates markdown files for R and final typeset PDF" do
        run_command_and_stop 'proptax reports aruba_data/ --ylimit 15000'
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.md')).to be true
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.pdf')).to be true
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.Rmd')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.md')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.pdf')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.Rmd')).to be true
      end 

      it "writes the correct R markdown to the files" do
        run_command_and_stop 'proptax reports aruba_data/ --ylimit 15000'
  
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11363 ROCKYVALLEY DR NW"/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 465000/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "aruba_data\/\/consolidated.csv"/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\),/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/limits=c\(min\(assessedValues\)-15000, max\(assessedValues\)\+15000\)\) \+/)
  
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11367 ROCKYVALLEY DR NW"/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 473000/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "aruba_data\/\/consolidated.csv"/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\),/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/limits=c\(min\(assessedValues\)-15000, max\(assessedValues\)\+15000\)\) \+/)
      end 
    end 

    describe 'no-ylimit option' do
      it "creates markdown files for R and final typeset PDF" do
        run_command_and_stop 'proptax reports aruba_data/ --no-ylimit'
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.md')).to be true
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.pdf')).to be true
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.Rmd')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.md')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.pdf')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.Rmd')).to be true
      end 

      it "writes the correct R markdown to the files" do
        run_command_and_stop 'proptax reports aruba_data/ --no-ylimit'
  
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11363 ROCKYVALLEY DR NW"/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 465000/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "aruba_data\/\/consolidated.csv"/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\)\) \+/)
  
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11367 ROCKYVALLEY DR NW"/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 473000/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "aruba_data\/\/consolidated.csv"/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\)\) \+/)
      end 
    end

    #
    # By default, `proptax` is meant to process contiguous properties. The `cherry-picked` template accommodates
    # non-contiguous properties
    #
    describe 'template option' do
      it "creates markdown files for R and final typeset PDF" do
        run_command_and_stop 'proptax reports aruba_data/ --template cherry-picked'
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.md')).to be true
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.pdf')).to be true
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.Rmd')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.md')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.pdf')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.Rmd')).to be true
      end 

      it "writes the correct R markdown to the files" do
        run_command_and_stop 'proptax reports aruba_data/ --template cherry-picked'
  
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11363 ROCKYVALLEY DR NW"/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 465000/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "aruba_data\/\/consolidated.csv"/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\),/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/limits=c\(min\(assessedValues\)-10000, max\(assessedValues\)\+10000\)\) \+/)

        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11367 ROCKYVALLEY DR NW"/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 473000/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "aruba_data\/\/consolidated.csv"/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\),/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/limits=c\(min\(assessedValues\)-10000, max\(assessedValues\)\+10000\)\) \+/)
      end 
    end 

    describe 'auto option' do
      it "creates markdown files for R and final typeset PDF" do
        run_command_and_stop 'proptax auto aruba_data/'
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.md')).to be true
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.pdf')).to be true
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.Rmd')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.md')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.pdf')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.Rmd')).to be true
      end 

      it "writes the correct R markdown to the files" do
        run_command_and_stop 'proptax auto aruba_data/'
  
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11363 ROCKYVALLEY DR NW"/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 465000/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "consolidated.csv"/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\),/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/limits=c\(min\(assessedValues\)-10000, max\(assessedValues\)\+10000\)\) \+/)

        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11367 ROCKYVALLEY DR NW"/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 473000/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "consolidated.csv"/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\),/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/limits=c\(min\(assessedValues\)-10000, max\(assessedValues\)\+10000\)\) \+/)
      end 
    end 

    describe 'auto ylimit options' do
      it "creates markdown files for R and final typeset PDF" do
        run_command_and_stop 'proptax auto aruba_data/ --ylimit=12345'
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.md')).to be true
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.pdf')).to be true
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.Rmd')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.md')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.pdf')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.Rmd')).to be true
      end 

      it "writes the correct R markdown to the files" do
        run_command_and_stop 'proptax auto aruba_data/ --ylimit=12345'
  
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11363 ROCKYVALLEY DR NW"/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 465000/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "consolidated.csv"/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\),/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/limits=c\(min\(assessedValues\)-12345, max\(assessedValues\)\+12345\)\) \+/)

        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11367 ROCKYVALLEY DR NW"/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 473000/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "consolidated.csv"/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\),/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/limits=c\(min\(assessedValues\)-12345, max\(assessedValues\)\+12345\)\) \+/)
      end 
    end 

    describe 'auto no-ylimit options' do
      it "creates markdown files for R and final typeset PDF" do
        run_command_and_stop 'proptax auto aruba_data/ --no-ylimit'
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.md')).to be true
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.pdf')).to be true
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.Rmd')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.md')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.pdf')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.Rmd')).to be true
      end 

      it "writes the correct R markdown to the files" do
        run_command_and_stop 'proptax auto aruba_data/ --no-ylimit'
  
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11363 ROCKYVALLEY DR NW"/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 465000/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "consolidated.csv"/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\)\) \+/)

        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11367 ROCKYVALLEY DR NW"/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 473000/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "consolidated.csv"/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\)\) \+/)
      end 
    end 

    describe 'auto template options' do
      it "creates markdown files for R and final typeset PDF" do
        run_command_and_stop 'proptax auto aruba_data/ --template cherry-picked'
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.md')).to be true
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.pdf')).to be true
        expect(file?('reports/11363_ROCKYVALLEY_DR_NW.Rmd')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.md')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.pdf')).to be true
        expect(file?('reports/11367_ROCKYVALLEY_DR_NW.Rmd')).to be true
      end 

      it "writes the correct R markdown to the files" do
        run_command_and_stop 'proptax auto aruba_data/ --template cherry-picked'
  
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11363 ROCKYVALLEY DR NW"/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 465000/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "consolidated.csv"/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\),/)
        expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/limits=c\(min\(assessedValues\)-10000, max\(assessedValues\)\+10000\)\) \+/)

        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11367 ROCKYVALLEY DR NW"/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 473000/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "consolidated.csv"/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\),/)
        expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/limits=c\(min\(assessedValues\)-10000, max\(assessedValues\)\+10000\)\) \+/)
      end 
    end 
  end
end
