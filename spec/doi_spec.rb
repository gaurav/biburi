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
                "doi:10.1038/171737a0" => [
                    BibTeX::Entry.new(
                        :url => "http://dx.doi.org/10.1038/171737a0", 
                        :doi => "10.1038/171737a0",
                        :title => "Molecular Structure of Nucleic Acids: A Structure for Deoxyribose Nucleic Acid, year = 1953, journal = Nature, pages = 737-738", 
                        :author => "WATSON, J. D. and CRICK, F. H. C.", 
                        :date => "1953",
                        :volume => "171", 
                        :number => "4356"
                    )
                ],
                "http://dx.doi.org/10.1111/j.1096-0031.2010.00329.x" => [
                    BibTeX::Entry.new({
                        "url" => "http://dx.doi.org/10.1111/j.1096-0031.2010.00329.x",
                        "doi" => "10.1111/j.1096-0031.2010.00329.x",
                        "title" => "SequenceMatrix: concatenation software for the fast assembly of multi-gene datasets with character set and codon information",
                        "year" => "2011",
                        "journal" => "Cladistics", 
                        "pages" => "171-180",
                        "author" => "Vaidya, Gaurav and Lohman, David J. and Meier, Rudolf",
                        "date" => "2011",
                        "volume" => "27", 
                        "number" => "2"
                    })
                ]
            }

            queries.keys.each do |query|
                result = BibURI::Driver::DOI::lookup(query)

                expect(result.to_s).to eq(queries[query].to_s)
            end 
        end
    end
end
