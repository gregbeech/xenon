require 'xenon/headers/accept_encoding'

describe Xenon::Headers::AcceptEncoding do

  context '::parse' do
    %w(identity compress x-compress deflate gzip x-gzip *).each do |cc|
      it "can parse the #{cc} content coding" do
        header = Xenon::Headers::AcceptEncoding.parse(cc)
        expect(header.coding_ranges.size).to eq(1)
        expect(header.coding_ranges[0].to_s).to eq(cc)
      end
    end

    it 'can parse the fifth example from RFC 7231 § 5.3.4 with the right precedence' do
      header = Xenon::Headers::AcceptEncoding.parse('gzip;q=1.0, identity; q=0.5, *;q=0')
      expect(header.coding_ranges.size).to eq(3)
      expect(header.coding_ranges[0].to_s).to eq('gzip')
      expect(header.coding_ranges[1].to_s).to eq('identity; q=0.5')
      expect(header.coding_ranges[2].to_s).to eq('*; q=0.0')
    end

    it 'parses an empty header as containing no codings' do
      header = Xenon::Headers::AcceptEncoding.parse('')
      expect(header.coding_ranges.size).to eq(0) 
    end
  end

  context '#merge' do
    it 'can merge two headers with the right precedence' do
      h1 = Xenon::Headers::AcceptEncoding.parse('identity; q=0.5')
      h2 = Xenon::Headers::AcceptEncoding.parse('gzip;q=1.0, *;q=0')
      header = h1.merge(h2)
      expect(header.coding_ranges.size).to eq(3)
      expect(header.coding_ranges[0].to_s).to eq('gzip')
      expect(header.coding_ranges[1].to_s).to eq('identity; q=0.5')
      expect(header.coding_ranges[2].to_s).to eq('*; q=0.0')
    end
  end

end