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
        it "should be able to do DOI lookups" do
            queries = {
                "doi:10.1038/171737a0" => [
                    BibTeX::Entry.new(
                        :identifiers => "info:doi/http://dx.doi.org/10.1038/171737a0\nhttp://dx.doi.org/10.1038/171737a0",
                        :journal => "Nature",
                        :pages => "737--738",
                        :author => "WATSON, J. D. and CRICK, F. H. C.", 
                        :title => "Molecular Structure of Nucleic Acids: A Structure for Deoxyribose Nucleic Acid", 
                        :date => "1953",
                        :volume => "171", 
                        :number => "4356",
                        :url => "http://dx.doi.org/10.1038/171737a0",
                        :doi => "10.1038/171737a0",
                        :year => "1953"
                    )
                ],
                "http://dx.doi.org/10.1111/j.1096-0031.2010.00329.x" => [
                    BibTeX::Entry.new({
                        "identifiers" => "info:doi/http://dx.doi.org/10.1111/j.1096-0031.2010.00329.x\nhttp://dx.doi.org/10.1111/j.1096-0031.2010.00329.x",
                        "journal" => "Cladistics", 
                        "pages" => "171--180",
                        "author" => "Vaidya, Gaurav and Lohman, David J. and Meier, Rudolf",
                        "title" => "SequenceMatrix: concatenation software for the fast assembly of multi-gene datasets with character set and codon information",
                        "date" => "2011",
                        "volume" => "27", 
                        "number" => "2",
                        "url" => "http://dx.doi.org/10.1111/j.1096-0031.2010.00329.x",
                        "doi" => "10.1111/j.1096-0031.2010.00329.x",
                        "year" => "2011"
                    })
                ]
            }

            queries.keys.each do |query|
                result = BibURI::lookup(query)

                expect(result.to_s).to eq(queries[query].to_s)
            end 
        end

        it "should be able to do COinS lookups" do
            queries = {
                "http://www.mendeley.com/research/outline-morphometric-approach-identifying-fossil-spiders-preliminary-examination-florissant-formation/" => [
                    BibTeX::Entry.new(
                        :identifiers => "info:doi/10.1130/2008.2435(07).\nhttp://www.mendeley.com/research/outline-morphometric-approach-identifying-fossil-spiders-preliminary-examination-florissant-formation/",
                        :journal => "Society", 
                        :pages => "105", 
                        :author => "Kinchloe Roberts, A and Smith, D M and Guralnick, R P and Cushing, P E and Krieger, J",
                        :title => "An outline morphometric approach to identifying fossil spiders: A preliminary examination from the Florissant Formation",
                        :date => "2008", 
                        :volume => "435", 
                        :number => "303", 
                        :url => "http://www.mendeley.com/research/outline-morphometric-approach-identifying-fossil-spiders-preliminary-examination-florissant-formation/",
                        :doi => "10.1130/2008.2435(07)." # This is wrong though
                    )
                ],
                "http://www.mendeley.com/catalog/big-questions-biodiversity-informatics/" => [
                    BibTeX::Entry.new(
                        :identifiers => "info:doi/10.1080/14772001003739369 http://www.mendeley.com/catalog/big-questions-biodiversity-informatics/",
                        :journal => "Systematics and Biodiversity",
                        :pages => "159-168",
                        :author => "Peterson, A Townsend and Knapp, Sandra and Guralnick, Robert and Soberón, Jorge and Holder, Mark T",
                        :title => "The big questions for biodiversity informatics",
                        :date => "2010",
                        :volume => "8",
                        :number => "2",
                        :issn => "14772000",
                        :url => "http://www.mendeley.com/catalog/big-questions-biodiversity-informatics/",
                        :doi => "10.1080/14772001003739369"
                    )
                ],
                "http://www.mendeley.com/catalog/biodiversity-informatics-automated-approaches-documenting-global-biodiversity-patterns-processes/" => [
                    BibTeX::Entry.new(
                        :identifiers => "info:pmid/19129210 http://www.mendeley.com/catalog/biodiversity-informatics-automated-approaches-documenting-global-biodiversity-patterns-processes/",
                        :journal => "Bioinformatics",
                        :pages => "421-428",
                        :author => "Guralnick, Robert and Hill, Andrew",
                        :title => "Biodiversity informatics: automated approaches for documenting global biodiversity patterns and processes.",
                        :date => "2009",
                        :volume => "25",
                        :number => "4",
                        :url => "http://www.mendeley.com/catalog/biodiversity-informatics-automated-approaches-documenting-global-biodiversity-patterns-processes/"
                    )
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
