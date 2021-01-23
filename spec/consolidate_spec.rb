require 'spec_helper'

describe Proptax::Consolidator do

  describe '#process' do
    before(:all) do
      # Non-breaking spaces mess tests up (so do soft hyphens). This removes them
      @results = File.read('spec/data/expected_imperial.csv').gsub("\u00A0", " ").gsub(/\u00AD/, '')
      @data = File.read('spec/data/sample.txt')
    end

    before(:each) do
      # For future reference, this is stubbing the `pdftotext` call.
      # As a consequence, `expected_imperial.csv` has two identical records.
      # Cf. `writes CSV data to stdout` test
      allow(subject).to receive(:`).and_return(@data)
    end

    context 'program is executed with directory name argument' do
      subject { Proptax::Consolidator }

      it 'doesn\'t barf if the directory doesn\'t exist' do
        expect { subject.process('no_such_dir') }.to output("Directory no_such_dir does not exist\n").to_stdout
        expect { subject.process('/no_such_dir') }.to output("Directory /no_such_dir does not exist\n").to_stdout
        expect { subject.process('') }.to output("No directory specified\n").to_stdout
        expect { subject.process('    ') }.to output("No directory specified\n").to_stdout
      end

      it 'calls `pdftotext` for every PDF in the directory' do
        expect(subject).to receive(:`).with("pdftotext \"#{__dir__}/data/fake1.pdf\" -").once
        expect(subject).to receive(:`).with("pdftotext \"#{__dir__}/data/fake2.PDF\" -").once
        subject.process('spec/data')
      end

      it 'writes CSV data to stdout' do
        expect { subject.process('spec/data') }.to output(@results).to_stdout
      end
    end
  end

  describe '#parse' do
    it 'returns a CSV-ready record' do
      csv = Proptax::Consolidator.parse File.read('spec/data/sample.txt')
      expected_imperial = ['465000', '438098303', '11363 ROCKYVALLEY DR NW', 'Taxable', 'Residential 100%',
                           'Land and Improvement', 'Single Residential', 'Sales Comparison', 'F',
                           'Rocky Ridge', 'SNGLRES NORTH', '001', 'SNGLRES A',
                           'Traffic Collector', 'Residential - Contextual One Dwelling', '4860', '1',
                           'House / 2 Storey', '2002', 'Average', '1859', '488', 'Attached', '383', 'Fireplace (1)']

      expect(csv.length).to eq(expected_imperial.length)
      expect(csv.length).to eq(Proptax::Consolidator::Headers.length)
      expected_imperial.each_with_index do |val, index|
        expect(csv[index]).to eq(val)
      end
    end

    it 'returns a CSV-ready record with Below Grade value set to 0, if Below Grade not present' do
      csv = Proptax::Consolidator.parse File.read('spec/data/sample_no_below_grade.txt')
      expected_imperial = ['458500', '438099608', '11311 ROCKYVALLEY DR NW', 'Taxable', 'Residential 100%',
                           'Land and Improvement', 'Single Residential', 'Sales Comparison', 'F',
                           'Rocky Ridge', 'SNGLRES NORTH', '001', 'SNGLRES A',
                           'Traffic Collector', 'Residential - Contextual One Dwelling', '4176', '1',
                           'House / 2 Storey', '2002', 'Average', '1831', '0', 'Attached', '396',
                           'Walk Out Basement/Fireplace (1)']

      expect(csv.length).to eq(expected_imperial.length)
      expect(csv.length).to eq(Proptax::Consolidator::Headers.length)
      expected_imperial.each_with_index do |val, index|
        expect(csv[index]).to eq(val)
      end
    end

    #
    # This is also reflected in the test above (i.e., No Below Grade). Same data, same house
    #
    it 'returns slash-seperated values for multiple features' do
      csv = Proptax::Consolidator.parse File.read('spec/data/sample_multi_features.txt')
      expected_imperial = ['506500', '438099707', '11307 ROCKYVALLEY DR NW', 'Taxable', 'Residential 100%',
                           'Land and Improvement', 'Single Residential', 'Sales Comparison', 'F',
                           'Rocky Ridge', 'SNGLRES NORTH', '001', 'SNGLRES A',
                           'Traffic Collector', 'Residential - Contextual One Dwelling', '4854', '1',
                           'House / 2 Storey', '2000', 'Average', '1960', '750', 'Attached', '427',
                           'Walk Out Basement/Fireplace (1)']

      expect(csv.length).to eq(expected_imperial.length)
      expect(csv.length).to eq(Proptax::Consolidator::Headers.length)
      expected_imperial.each_with_index do |val, index|
        expect(csv[index]).to eq(val)
      end
    end

    #
    # TODO: get rasterized PDF, as produced by Windows 7
    #
#    it 'returns a CSV-ready record from tesseract text extraction' do
#      csv = Proptax::Consolidator.parse File.read('spec/data/tesseract-sample.txt')
#      expected_imperial = ['000000422', '80 FAKE ST NW', '599000', 'Sales Comparison',
#                           'Residential 100%','Land and Improvement', 'Single Residential', 'Taxable',
#                           'Royal Oak', '001', 'SNGLRES WEST', 'SNGLRES B',
#                           'Residential - Contextual One Dwelling', '6173', '1', 'House / 2 Storey',
#                           '2006', 'Average', '2442', '0', 'F', 'F', 'Attached', '437', 'T']
#      expect(csv.length).to eq(expected_imperial.length)
#      expect(csv.length).to eq(Proptax::Consolidator::Headers.length)
#      expected_imperial.each_with_index do |val, index|
#        expect(csv[index]).to eq(val)
#      end
#    end

    it 'returns slash-seperated values for multiple influencing factors' do
      csv = Proptax::Consolidator.parse File.read('spec/data/sample_multi_influences.txt')
      expected_imperial = ['485500', '438099806', '11303 ROCKYVALLEY DR NW', 'Taxable', 'Residential 100%',
                           'Land and Improvement', 'Single Residential', 'Sales Comparison', 'F',
                           'Rocky Ridge', 'SNGLRES NORTH', '001', 'SNGLRES A',
                           'Corner Lot/Traffic Collector/Green Space - Athletic Field Road',
                           'Residential - Contextual One Dwelling', '5368', '1', 'House / 2 Storey',
                           '2000', 'Average', '1940', '602', 'Attached', '420', 'Fireplace (1)']

      expect(csv.length).to eq(expected_imperial.length)
      expect(csv.length).to eq(Proptax::Consolidator::Headers.length)
      expected_imperial.each_with_index do |val, index|
        expect(csv[index]).to eq(val)
      end
    end
  end

  describe '#clean' do
    it 'removes commas from Current Year Assessed Value' do
      expect(Proptax::Consolidator.clean('500', Proptax::Consolidator::Headers[0])).to eq('500')
      expect(Proptax::Consolidator.clean('505,500', Proptax::Consolidator::Headers[0])).to eq('505500')
      expect(Proptax::Consolidator.clean('1,234,555', Proptax::Consolidator::Headers[0])).to eq('1234555')
    end

    it 'leaves only square footage from Assessable Land Area' do
      expect(Proptax::Consolidator.clean('5,368 sq. ft. / 499 sq. m. / 0.12 ac', Proptax::Consolidator::Headers[15])).to eq('5368')
      expect(Proptax::Consolidator.clean('368 sq. ft. / 499 sq. m. / 0.12 ac', Proptax::Consolidator::Headers[15])).to eq('368')
      expect(Proptax::Consolidator.clean('1,500,368 sq. ft. / 499 sq. m. / 0.12 ac', Proptax::Consolidator::Headers[15])).to eq('1500368')
    end

    it 'leaves only square footage from Total Living Area Above Grade' do
      expect(Proptax::Consolidator.clean('940 sq. ft. / 180 sq. m.', Proptax::Consolidator::Headers[20])).to eq('940')
      expect(Proptax::Consolidator.clean('1,940 sq. ft. / 180 sq. m.', Proptax::Consolidator::Headers[20])).to eq('1940')
      expect(Proptax::Consolidator.clean('1,123,940 sq. ft. / 180 sq. m.', Proptax::Consolidator::Headers[20])).to eq('1123940')
    end

    it 'leaves only square footage from Living Area Below Grade' do
      expect(Proptax::Consolidator.clean('602 sq. ft. / 56 sq. m.', Proptax::Consolidator::Headers[21])).to eq('602')
      expect(Proptax::Consolidator.clean('1,602 sq. ft. / 56 sq. m.', Proptax::Consolidator::Headers[21])).to eq('1602')
      expect(Proptax::Consolidator.clean('3,999,602 sq. ft. / 56 sq. m.', Proptax::Consolidator::Headers[21])).to eq('3999602')
    end

    it 'leaves only square footage from Garage Area' do
      expect(Proptax::Consolidator.clean('420 sq. ft. / 39 sq. m.', Proptax::Consolidator::Headers[23])).to eq('420')
      expect(Proptax::Consolidator.clean('1,420 sq. ft. / 39 sq. m.', Proptax::Consolidator::Headers[23])).to eq('1420')
      expect(Proptax::Consolidator.clean('2,555,420 sq. ft. / 39 sq. m.', Proptax::Consolidator::Headers[23])).to eq('2555420')
    end
  end
end
