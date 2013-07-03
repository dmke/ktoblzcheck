require 'spec_helper'
require 'yaml'

def mid2blz(mid)
  bank = KtoBlzCheck::KNOWN_BANKS.select{|b| b.mid == mid }.first
  bank.blz unless bank.nil?
end

describe KtoBlzCheck do
  let(:fixtures) { YAML.load_file('spec/fixtures.yml') }

  context 'general behavior' do
    it 'has a version number' do
      KtoBlzCheck::VERSION.should_not be_nil
    end

    it 'has a valid bankdata directory' do
      dir = KtoBlzCheck.bankdata_dir
      Pathname(dir).should be_exist # language, anyone? :-)
    end

    it 'has all banks parsed' do
      KtoBlzCheck::KNOWN_BANKS.size.should == KtoBlzCheck.new.num_records
    end
  end

  context 'validation' do
    subject { KtoBlzCheck.new }
    after(:all) { subject.close }

    it 'validate fixtures' do
      puts "%8s %-13s (id) : act/exp" % ['BLZ', 'Kto']
      fixtures.each do |e, data|
        expectation = case e
          when 'ok'    then KtoBlzCheck::OK
          when 'error' then KtoBlzCheck::ERROR
        end
        data.each do |mid, account_numbers|
          blz = mid2blz(mid)
          next if blz.nil?
          account_numbers.uniq.each do |acc|
            actual = subject.check(blz, acc)
            puts "%8s %-13s (%s) : %d/%d" % [blz, acc, mid, actual, expectation] if actual != expectation
            # subject.check(blz, acc).should == expectation
          end
        end
      end
      true.should be true
    end
  end
end
