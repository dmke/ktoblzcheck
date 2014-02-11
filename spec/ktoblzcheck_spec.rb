require 'spec_helper'
require 'yaml'

def mid2blz(mid)
  bank = KtoBlzCheck::KNOWN_BANKS.select{|b| b.mid == mid }.first
  bank.blz unless bank.nil?
end

def fixtures
  @fixtures ||= YAML.load_file('spec/fixtures.yml')
end

describe KtoBlzCheck do
  context 'definitions' do
    context 'of class methods' do
      subject { KtoBlzCheck }

      it { should respond_to :bankdata_dir }
      it { should respond_to :encoding }
    end

    context 'of instance methods' do
      subject { KtoBlzCheck.new }
      after(:all) { subject.close }

      it { should respond_to :check }
      it { should respond_to :num_records }
      it { should respond_to :close }
      it { should respond_to :find }
    end

    context 'of constant' do
      [
        :VERSION,
        :KNOWN_BANKS,
        :OK,
        :UNKNOWN,
        :ERROR,
        :BANK_NOT_KNOWN
      ].each do |c|
        it c.to_s do
          KtoBlzCheck.const_get(c).should be
        end
      end
    end
  end

  context 'general behavior' do
    it 'has a valid bankdata directory' do
      dir = KtoBlzCheck.bankdata_dir
      Pathname(dir).should be_exist # language, anyone? :-)
    end

    it 'has all banks parsed' do
      KtoBlzCheck::KNOWN_BANKS.size.should == KtoBlzCheck.new.num_records
    end
  end

  # some additional tests
  if ENV['CHECK_SAMPLE_DATA'] == 'true'
    context 'fixture validation' do
      subject { KtoBlzCheck.new }
      after(:each) { subject.close }

      fixtures.each do |e, data|
        expectation = case e
          when 'ok'    then KtoBlzCheck::OK
          when 'error' then KtoBlzCheck::ERROR
        end

        data.each do |mid, account_numbers|
          blz = mid2blz(mid)
          next if blz.nil?
          account_numbers.each do |acc|
            it "blz #{blz}, acc. #{acc}" do
              subject.check(blz, acc).should == expectation
            end
          end
        end

      end # each fixture set
    end # context
  end # if

end
