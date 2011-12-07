require 'date'

describe 'sending a birthday present to a customer' do
  let(:today) { Date.parse("2011-10-09") }
  context 'non-east customers' do
    let(:tomorrow_20_years_ago) { Date.parse("1991-10-10") }
    let(:today_20_years_ago) { Date.parse("1991-10-09") }

    it 'sends flowers to a female customer on their birthday' do
      customer = double(sex: :female, date_of_birth: today_20_years_ago)

      selector = NonEast::BirthdayPresentSelector.new(customer, today)
      selector.present.should == :flowers
    end

    it 'sends cufflinks to a male customer on their birthday' do
      customer = double(sex: :male, date_of_birth: today_20_years_ago)

      selector = NonEast::BirthdayPresentSelector.new(customer, today)
      selector.present.should == :cufflinks
    end

    it 'sends nothing to a female customer when it is not their birthday' do
      customer = double(sex: :female, date_of_birth: tomorrow_20_years_ago)

      selector = NonEast::BirthdayPresentSelector.new(customer, today)
      selector.present.should == :none
    end

    it 'sends nothing to a male customer when it is not their birthday' do
      customer = double(sex: :male, date_of_birth: tomorrow_20_years_ago)

      selector = NonEast::BirthdayPresentSelector.new(customer, today)
      selector.present.should == :none
    end
  end

  context 'east customers' do
    it 'sends flowers to a female customer on their birthday' do
      customer = double(male?: false)
      customer.stub(:birthday_on?).with(today) { true }
      selector = East::BirthdayPresentSelector.new(customer, today)
      delivery_service = double
      delivery_service.should_receiver(:deliver).with(:flowers)
      selector.deliver_present_with(delivery_service)
    end
  end
end

module NonEast
  class BirthdayPresentSelector
    def initialize(customer, today = Date.today)
      @customer = customer
      @today = today
    end

    def present
      return selected_present if birthday_today?
      :none
    end

    private
    def selected_present
      return :cufflinks if @customer.sex == :male
      :flowers
    end

    def birthday_today?
      @customer.date_of_birth.month == @today.month && @customer.date_of_birth.mday == @today.mday
    end
  end
end
