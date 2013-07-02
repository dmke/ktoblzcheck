require 'ktoblzcheck/ktoblzcheck'
require 'pathname'

class KtoBlzCheck
  # A simple data structure to hold basic bank information.
  #
  # @param blz        "Bankleitzahl, BLZ", German bank identification number
  # @param mid        checksum method id (is only internally used)
  # @param name       bank name
  # @param location   bank location
  class Bank < Struct.new(:blz, :mid, :name, :location)
    # @returns string representation
    def to_s
      [blz, name, location].join(', ')
    end

    # Check whether BLZ, name or location matches against query parameter.
    #
    # @param [Regexp] query
    # @returns A truthy value, if match was positive
    def matches?(query)
      [blz, name, location].any?{|e| e =~ query }
    end
  end

  # an exhaustive list of banks.
  KNOWN_BANKS = begin
    known = []
    Pathname.new(bankdata_dir).children.select{|c|
      c.basename.to_s =~ /^bankdata.*\.txt$/
    }.sort.last.open("r:#{encoding}:#{__ENCODING__}") do |f|
      f.readlines.each do |l|
        known << Bank.new(*l.strip.split("\t"))
      end
    end
    known
  end

  # Query the known banks and search for the given particle.
  #
  # @param [#to_s] query    a particle to match against BLZ, bank name or bank location.
  # @param [int|nil] limit  maximum result length (default to 10), `nil` disables limit.
  # @returns [Array]         query result list
  def self.search(query, limit=10)
    candidates = []
    q = Regexp.new Regexp.escape(query), Regexp::IGNORECASE

    KNOWN_BANKS.each do |b|
      break if candidates.size > limit
      candidates << b.to_s if b.matches?(q)
    end

    candidates
  end
end