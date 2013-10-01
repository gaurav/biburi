require_relative 'spec_helper'

describe BibURI::Driver::DOI do
    describe "supported" do
        it "should support real DOIs" do
            real_dois = [
                "doi:10.1111/j.1529-8817.2010.00939.x",
                "doi:10.1038/171737a0",
                "DOI:10.1038/171737A0",
                "http://dx.doi.org/doi:10.1038/171737a0"
            ]

            real_dois.each do |doi|
                expect(BibURI::Driver::DOI::supported?(doi)).to be_true;
            end
        end

        it "should not support incorrect DOIs" do
            incorrect_dois = [
                "10.1111/j.1529-8817.2010.00939.x",
                "dxoi:10.1038/171737a0",
                "https://dx.doi.org/doi:10.1038/171737a0"
            ]

            incorrect_dois.each do |doi|
                expect(BibURI::Driver::DOI::supported?(doi)).to be_false;
            end

        end
    end

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
