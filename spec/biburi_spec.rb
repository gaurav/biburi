require_relative 'spec_helper'

describe BibURI do
    describe "VERSION" do
        it "should exist" do
            version = BibURI::VERSION
        end
    end

    describe "drivers" do
        it "should have multiple drivers" do
            drivers = BibURI::drivers

            expect(drivers).to be_an_instance_of(Array)
            expect(drivers.length).to be > 0
        end
    end

    describe "lookup" do
        it "should be able to do simple lookups" do
            queries = {
                "doi:10.1038/171737a0" => [
                    BibTeX::Entry.new(
                        :url => "http://dx.doi.org/10.1038/171737a0", 
                        :identifiers => [ "http://dx.doi.org/10.1038/171737a0", "info:doi/http://dx.doi.org/10.1038/171737a0" ],
                        :doi => "10.1038/171737a0",
                        :title => "Molecular Structure of Nucleic Acids: A Structure for Deoxyribose Nucleic Acid, year = 1953, journal = Nature, pages = 737--738", 
                        :author => "WATSON, J. D. and CRICK, F. H. C.", 
                        :date => "1953",
                        :volume => "171", 
                        :number => "4356"
                    )
                ],
                "http://dx.doi.org/10.1111/j.1096-0031.2010.00329.x" => [
                    BibTeX::Entry.new({
                        "url" => "http://dx.doi.org/10.1111/j.1096-0031.2010.00329.x",
                        "identifiers" => [ "http://dx.doi.org/10.1111/j.1096-0031.2010.00329.x", "info:doi/http://dx.doi.org/10.1111/j.1096-0031.2010.00329.x" ],
                        "doi" => "10.1111/j.1096-0031.2010.00329.x",
                        "title" => "SequenceMatrix: concatenation software for the fast assembly of multi-gene datasets with character set and codon information",
                        "year" => "2011",
                        "journal" => "Cladistics", 
                        "pages" => "171--180",
                        "author" => "Vaidya, Gaurav and Lohman, David J. and Meier, Rudolf",
                        "date" => "2011",
                        "volume" => "27", 
                        "number" => "2"
                    })
                ]
            }

            queries.keys.each do |query|
                result = BibURI::lookup(query)

                expect(result.to_s).to eq(queries[query].to_s)
            end 
        end
    end
end

describe BibURI::Driver do
    it "should return NotImplementedError for all methods" do
        expect { BibURI::Driver::supported?("doi:10.1038/171737a0") }.to raise_error(NotImplementedError)
        expect { BibURI::Driver::canonical("doi:10.1038/171737a0") }.to raise_error(NotImplementedError)
        expect { BibURI::Driver::lookup("doi:10.1038/171737a0") }.to raise_error(NotImplementedError)
    end
end
