# encoding: utf-8

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
                "doi:10.1038/171737a0" =>
                    BibTeX::Entry.new(
                        :type => 'article',
                        :identifiers => "info:doi/http://dx.doi.org/10.1038/171737a0\nhttp://dx.doi.org/10.1038/171737a0",
                        :journal => "Nature",
                        :pages => "737--738",
                        :author => "WATSON, J. D. and CRICK, F. H. C.", 
                        :date => "1953",
                        :year => "1953",
                        :title => "Molecular Structure of Nucleic Acids: A Structure for Deoxyribose Nucleic Acid", 
                        :volume => "171", 
                        :number => "4356",
                        :url => "http://dx.doi.org/10.1038/171737a0",
                        :doi => "10.1038/171737a0",
                    ),
                "http://dx.doi.org/10.1111/j.1096-0031.2010.00329.x" =>
                    BibTeX::Entry.new({
                        :type => 'article',
                        "identifiers" => "info:doi/http://dx.doi.org/10.1111/j.1096-0031.2010.00329.x\nhttp://dx.doi.org/10.1111/j.1096-0031.2010.00329.x",
                        "journal" => "Cladistics", 
                        "pages" => "171--180",
                        "author" => "Vaidya, Gaurav and Lohman, David J. and Meier, Rudolf",
                        "date" => "2011",
                        "year" => "2011",
                        "title" => "SequenceMatrix: concatenation software for the fast assembly of multi-gene datasets with character set and codon information",
                        "volume" => "27", 
                        "number" => "2",
                        "url" => "http://dx.doi.org/10.1111/j.1096-0031.2010.00329.x",
                        "doi" => "10.1111/j.1096-0031.2010.00329.x",
                    })
            }

            queries.keys.each do |query|
                result = BibURI::lookup(query)

                expect(result.to_s).to eq(queries[query].to_s)
            end 
        end

        it "should be able to do COinS lookups" do
            queries = {
                "http://www.mendeley.com/research/outline-morphometric-approach-identifying-fossil-spiders-preliminary-examination-florissant-formation/" =>
                    BibTeX::Entry.new(
                        :type => 'article',
                        :identifiers => "info:doi/10.1130/2008.2435(07).\nhttp://www.mendeley.com/research/outline-morphometric-approach-identifying-fossil-spiders-preliminary-examination-florissant-formation/",
                        :journal => "Society", 
                        :pages => "105", 
                        :author => "Kinchloe Roberts, A and Smith, D M and Guralnick, R P and Cushing, P E and Krieger, J",
                        :date => "2008", 
                        :year => "2008",
                        :title => "An outline morphometric approach to identifying fossil spiders: A preliminary examination from the Florissant Formation",
                        :volume => "435", 
                        :number => "303", 
                        :url => "http://www.mendeley.com/research/outline-morphometric-approach-identifying-fossil-spiders-preliminary-examination-florissant-formation/",
                        :doi => "10.1130/2008.2435(07)." # This is wrong though
                    ),
                "http://www.mendeley.com/catalog/big-questions-biodiversity-informatics/" =>
                    BibTeX::Entry.new(
                        :type => 'article',
                        :identifiers => "info:doi/10.1080/14772001003739369\nhttp://www.mendeley.com/catalog/big-questions-biodiversity-informatics/",
                        :journal => "Systematics and Biodiversity",
                        :pages => "159--168",
                        :author => "Peterson, A Townsend and Knapp, Sandra and Guralnick, Robert and Soberón, Jorge and Holder, Mark T",
                        :date => "2010",
                        :year => "2010",
                        :title => "The big questions for biodiversity informatics",
                        :volume => "8",
                        :number => "2",
                        :issn => "14772000",
                        :url => "http://www.mendeley.com/catalog/big-questions-biodiversity-informatics/",
                        :doi => "10.1080/14772001003739369"
                    ),
                "http://www.mendeley.com/catalog/biodiversity-informatics-automated-approaches-documenting-global-biodiversity-patterns-processes/" => 
                    BibTeX::Entry.new(
                        :type => 'article',
                        :identifiers => "info:pmid/19129210\nhttp://www.mendeley.com/catalog/biodiversity-informatics-automated-approaches-documenting-global-biodiversity-patterns-processes/",
                        :journal => "Bioinformatics",
                        :pages => "421--428",
                        :author => "Guralnick, Robert and Hill, Andrew",
                        :date => "2009",
                        :year => "2009",
                        :title => "Biodiversity informatics: automated approaches for documenting global biodiversity patterns and processes.",
                        :volume => "25",
                        :number => "4",
                        :url => "http://www.mendeley.com/catalog/biodiversity-informatics-automated-approaches-documenting-global-biodiversity-patterns-processes/"
                    ),
                "http://www.mendeley.com/research/hs-2-w-estern-o-ffshoots-1500-2001-australia-canada-new-zealand-united-states/" => 
                    BibTeX::Entry.new(
                        :type => 'article',
                        :identifiers => "http://www.mendeley.com/research/hs-2-w-estern-o-ffshoots-1500-2001-australia-canada-new-zealand-united-states/",
                        :journal => "Work",
                        :pages => "71--90",
                        :author => "Offshoots, Western",
                        :date => "2001",
                        :year => "2001",
                        :title => "HS – 2 : W ESTERN O FFSHOOTS : 1500 – 2001 ( Australia , Canada , New Zealand , and the United States )",
                        :volume => "2001",
                        :isbn => "9264022619",
                        :url => "http://www.mendeley.com/research/hs-2-w-estern-o-ffshoots-1500-2001-australia-canada-new-zealand-united-states/"
                    ),
                "http://www.citeulike.org/user/bjbraams/article/12683220" => 
                    BibTeX::Entry.new(
                        :type => 'article',
                        :identifiers => "info:doi/10.1016/s0009-2614(02)00988-0\nhttp://www.citeulike.org/user/bjbraams/article/12683220",
                        :journal => "Chemical Physics Letters",
                        :pages => "520--524",
                        :author => "Scemama, Anthony and Chaquin, Patrick and Gazeau, Marie-Claire and Bénilan, Yves",
                        :date => "2002-8",
                        :year => "2002",
                        :month => "8",
                        :title => "Semi-empirical calculation of electronic absorption wavelengths of polyynes, monocyano- and dicyanopolyynes. Predictions for long chain compounds and carbon allotrope carbyne",
                        :volume => "361",
                        :number => "5-6",
                        :issn => "00092614",
                        :url => "http://www.citeulike.org/user/bjbraams/article/12683220",
                        :doi => "10.1016/s0009-2614(02)00988-0"
                    ),
                #"http://www.bioone.org/doi/abs/10.1642/0004-8038(2002)119%5B0897:FTSTTA%5D2.0.CO%3B2" => 
                #    BibTeX::Entry.new(
                #
                #    ),
                "http://www.biodiversitylibrary.org/part/87340#/summary" => 
                    BibTeX::Entry.new(
                        :type => 'article',
                        :identifiers => "info:doi/10.2307/4067078\nurn:ISSN:0004-8038\nhttp://www.biodiversitylibrary.org/part/87340\nhttp://www.biodiversitylibrary.org/part/87340#/summary",
                        :journal => "The Auk",
                        :pages => "60--66",
                        :author => "Allen, J A and Brewster, William and Coues, Elliott and Ridgway, Robert and Sage, John H",
                        :date => "1890",
                        :year => "1890",
                        :title => "Second Supplement to the American Ornithologists' Union Check-List of North American Birds",
                        :volume => "7",
                        :issn => "0004-8038",
                        :url => "http://www.biodiversitylibrary.org/part/87340#/summary",
                        :doi => "10.2307/4067078"
                    )
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
