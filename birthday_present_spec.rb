require 'date'

module NonEast
  describe 'sending a birthday present to a customer' do
    context 'non-east customers' do
      let(:today_20_years_ago) { Date.parse("1991-10-09") }
      let(:today) { Date.parse("2011-10-09") }

      it 'sends flowers to a female customer on their birthday' do
        customer = double(sex: :female, date_of_birth: today_20_years_ago)

        selector = BirthdayPresentSelector.new(customer, today)
        selector.present.should == :flowers
      end

      it 'sends cufflinks to a male customer on their birthday' do
        customer = double(sex: :male, date_of_birth: today_20_years_ago)

        selector = BirthdayPresentSelector.new(customer, today)
        selector.present.should == :cufflinks
      end

      it 'sends nothing to a female customer when it is not their birthday' do
        tomorrow_20_years_ago = Date.parse("1991-10-10")
        customer = double(sex: :female, date_of_birth: tomorrow_20_years_ago)

        selector = BirthdayPresentSelector.new(customer, today)
        selector.present.should == :none
      end
    end
  end

  class BirthdayPresentSelector
    def initialize(customer, today = Date.today)
      @customer = customer
    end

    def present
      return :cufflinks if @customer.sex == :male
      :flowers
    end
  end
end
