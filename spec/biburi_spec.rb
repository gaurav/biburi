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
end
