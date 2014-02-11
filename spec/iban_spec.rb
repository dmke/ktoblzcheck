require 'spec_helper'

describe KtoBlzCheck::IBAN do
  context 'definitions' do
    context 'of instance methods' do
      subject { KtoBlzCheck::IBAN.new }
      after(:all) { subject.close }

      it { should respond_to :check }
      it { should respond_to :close }
    end

    context 'of constant' do
      [
        :VERSION,
        :OK,
        :TOO_SHORT,
        :PREFIX_NOT_FOUND,
        :WRONG_LENGTH,
        :COUNTRY_NOT_FOUND,
        :WRONG_COUNTRY,
        :BAD_CHECKSUM
      ].each do |c|
        it c.to_s do
          KtoBlzCheck::IBAN.const_get(c).should be
        end
      end
    end
  end
end
