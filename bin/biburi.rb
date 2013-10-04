#!/usr/bin/env ruby

#
# A binary to access BibURI from the command line.
#
require 'biburi'
require 'optparse'

# Command line options
options = {}

# Reads command line arguments and figures out what to run.
def main
    # Process command line options.
    OptionParser.new do |opts|
        opts.banner = "Usage: biburi [arguments] [uri]\n\n" +
            "biburi can read any number of URIs in its arguments.\n" +
            "If no URI is provided, biburi will read URIs from STDIN\nand return one BibTeX citation per input line."

        opts.separator ""

        # Documentary stuff.
        opts.on("-h", "--help", "Show this message") do
            puts opts
        end

        opts.on("-v", "--[no-]verbose", "Produce verbose output") do |v|
            options[:verbose] = v
        end

        opts.separator ""
    end.parse!

    # Do we have command line argument URIs?
    if !ARGV.empty? then
        ARGV.each do |uri|
            uri_to_bibtex(uri)
        end
    else
        # If not, open STDIN and process that instead. 
        lines = STDIN.readlines
        lines.each do |line|
            line.chomp!
            uri_to_bibtex(line)
        end
    end
end

# Returns a URI as BibTeX thanks to the magic of BibURI.
def uri_to_bibtex(uri)
    entry = BibURI::lookup(uri)
    if entry.nil? then
        entry = BibTeX::Entry.new(
            :title => uri,
            :identifiers => uri
        )
    end

    puts entry.to_s
end

# Start execution
main()
