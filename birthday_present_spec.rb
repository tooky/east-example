require 'date'

module NonEast
  describe 'sending a birthday present to a customer' do
    context 'non-east customers' do

      it 'sends flowers to a female customer on their birthday' do
        today = Date.parse("2011-10-09")
        today_20_years_ago = Date.parse("1991-10-09")
        customer = double(sex: :female, date_of_birth: today_20_years_ago)

        selector = BirthdayPresentSelector.new(customer, today)
        selector.present.should == :flowers
      end

      it 'sends cufflinks to a male customer on their birthday' do
        today = Date.parse("2011-10-09")
        today_20_years_ago = Date.parse("1991-10-09")
        customer = double(sex: :male, date_of_birth: today_20_years_ago)

        selector = BirthdayPresentSelector.new(customer, today)
        selector.present.should == :cufflinks
      end
    end
  end

  class BirthdayPresentSelector
    def initialize(customer, today = Date.today)
    end

    def present
      :flowers
    end
  end
end
