# encoding: UTF-8

require 'ktoblzcheck/ktoblzcheck'
require 'pathname'

class KtoBlzCheck
  RESULT_CODES = {
    OK              => 'OK',
    UNKNOWN         => 'unknown validation algorithm',
    ERROR           => 'account and bank do not match',
    BANK_NOT_KNOWN  => 'bank is unknown'
  }

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

  def self.check(blz, kto)
    res = nil
    new {|e| res = e.check(blz.to_s, kto.to_s) }
    res
  end

  def self.check!(blz, kto)
    res = check(blz, kto)
    return true if res == OK
    raise KtoBlzCheck::Error, RESULT_CODES[res]
  end

  class IBAN
    RESULT_CODES = {
      OK                => 'IBAN is ok',
      TOO_SHORT         => 'IBAN is too short',
      PREFIX_NOT_FOUND  => 'unknown IBAN country prefix',
      WRONG_LENGTH      => 'wrong length of IBAN',
      COUNTRY_NOT_FOUND => 'country for IBAN not found',
      WRONG_COUNTRY     => 'IBAN prefix does not match for country',
      BAD_CHECKSUM      => 'bad checksum'
    }

    def self.check(iban)
      res = nil
      new {|e| res = e.check(iban.gsub(/\s+/, ''), iban[0,2].upcase) }
      res
    end

    def self.check!(iban)
      res = check(iban)
      return true if res == OK
      raise KtoBlzCheck::Error, RESULT_CODES[res]
    end
  end
end
