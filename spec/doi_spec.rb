require_relative 'spec_helper'

describe BibURI::Driver::DOI do
    describe "canonical" do
        it "should canonicalize DOIs correctly" do
            canonicalize = {
                "doi:10.1038/171737a0" => "http://dx.doi.org/10.1038/171737a0",
                "http://dx.doi.org/10.1038/171737a0" => "http://dx.doi.org/10.1038/171737a0"
            }

            canonicalize.keys.each do |value|
                expected = canonicalize[value]
                expect(BibURI::Driver::DOI::canonical(value)).to eq(expected)
            end
        end
    end
end
