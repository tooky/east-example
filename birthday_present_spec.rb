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
    let(:boy) { double(male?: true) }
    let(:girl) { double(male?: false) }
    let(:delivery_service) { double }

    it 'sends flowers to a female customer on their birthday' do
      girl.stub(:birthday_on?).with(today) { true }
      selector = East::BirthdayPresentSelector.new(girl, today)

      delivery_service.should_receive(:deliver).with(:flowers)
      selector.send_present(delivery_service)
    end

    it 'sends cufflinks to a male customer on their birthday' do
      boy.stub(:birthday_on?).with(today) { true }
      selector = East::BirthdayPresentSelector.new(boy, today)

      delivery_service.should_receive(:deliver).with(:cufflinks)
      selector.send_present(delivery_service)
    end

    it 'does not send a present to a female customer when it is not their birthday' do
      girl.stub(:birthday_on?).with(today) { false }
      selector = East::BirthdayPresentSelector.new(girl, today)

      delivery_service.should_not_receive(:deliver)
      selector.send_present(delivery_service)
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

module East
  class BirthdayPresentSelector
    def initialize(customer, today = Date.today)
      @customer = customer
    end

    def send_present(delivery_service)
      delivery_service.deliver(present)
    end

    private
    def present
      return :cufflinks if @customer.male?
      :flowers
    end
  end
end
