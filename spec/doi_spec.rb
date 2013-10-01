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

    describe "lookup" do
        it "should be able to download information on some DOIs" do
            queries = {
                "doi:10.1038/171737a0" => {
                    "title" => "J. D. WATSON, F. H. C. CRICK, 1953, 'Molecular Structure of Nucleic Acids: A Structure for Deoxyribose Nucleic Acid', <i>Nature</i>, vol. 171, no. 4356, pp. 737-738",
                    "year" => "1953"
                },
                "http://dx.doi.org/10.1111/j.1096-0031.2010.00329.x" => {
                    "title" => "Gaurav Vaidya, David J. Lohman, Rudolf Meier, 2011, 'SequenceMatrix: concatenation software for the fast assembly of multi-gene datasets with character set and codon information', <i>Cladistics</i>, vol. 27, no. 2, pp. 171-180",
                    "year" => "2011"
                },
                "doi:Hullo there" => {
                    "title" => "20 DOIs returned: http://dx.doi.org/10.7554/elife.00459.014, http://dx.doi.org/10.7554/elife.00190.025, http://dx.doi.org/10.7554/elife.00178.026, http://dx.doi.org/10.7554/elife.00288.003, http://dx.doi.org/10.7554/elife.00288.022, http://dx.doi.org/10.7554/elife.00288.031, http://dx.doi.org/10.7554/elife.00288.040, http://dx.doi.org/10.7554/elife.00288.041, http://dx.doi.org/10.7554/elife.00362.013, http://dx.doi.org/10.7554/elife.00005.020, http://dx.doi.org/10.7554/elife.00260.015, http://dx.doi.org/10.7554/elife.00426.019, http://dx.doi.org/10.7554/elife.00248.007, http://dx.doi.org/10.7554/elife.00231.018, http://dx.doi.org/10.7554/elife.00327.010, http://dx.doi.org/10.7554/elife.00312.018, http://dx.doi.org/10.7554/elife.00354.003, http://dx.doi.org/10.7554/elife.00354.008, http://dx.doi.org/10.7554/elife.00354.015, http://dx.doi.org/10.7554/elife.00067.017"
                }
            }

            queries.keys.each do |query|
                result = BibURI::Driver::DOI::lookup(query)

                expect(result).to eq(queries[query])
            end 
        end
    end
end
