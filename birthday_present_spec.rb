require 'date'

describe 'sending a birthday present to a customer' do
  let(:today) { Date.parse("2011-10-09") }
  context 'non-east' do
    subject { NonEast::BirthdayPresentSelector.new(customer, today) }
    let(:tomorrow_20_years_ago) { Date.parse("1991-10-10") }
    let(:today_20_years_ago) { Date.parse("1991-10-09") }

    context 'female customer' do
      let(:customer) { double(sex: :female) }

      it 'receives flowers on her birthday' do
        customer.stub(date_of_birth: today_20_years_ago)
        subject.present.should == :flowers
      end

      it 'receives nothing when it is not his birthday' do
        customer.stub(date_of_birth: tomorrow_20_years_ago)
        subject.present.should == :none
      end
    end

    context 'male customer' do
      let(:customer) { double(sex: :male) }

      it 'receives cufflinks when it is his birthday' do
        customer.stub(date_of_birth: today_20_years_ago)
        subject.present.should == :cufflinks
      end

      it 'receives nothing when it is not his birthday' do
        customer.stub(date_of_birth: tomorrow_20_years_ago)
        subject.present.should == :none
      end
    end

  end

  context 'east' do
    subject { East::BirthdayPresentSelector.new(customer, today) }
    let(:boy) { double(male?: true) }
    let(:girl) { double(male?: false) }

    context 'female customer' do
      let(:customer) { girl }
      it 'receives flowers on her birthday' do
        girl.stub(:birthday_on?).with(today) { true }

        girl.should_receive(:receive).with(:flowers)
        subject.send_present
      end

      it 'does not receive a present when it is not her birthday' do
        girl.stub(:birthday_on?).with(today) { false }

        girl.should_not_receive(:receive)
        subject.send_present
      end
    end

    context 'male customer' do
      let(:customer) { boy }

      it 'receives cufflinks on his birthday' do
        boy.stub(:birthday_on?).with(today) { true }

        boy.should_receive(:receive).with(:cufflinks)
        subject.send_present
      end

      it 'does not receive a present when it is not his birthday' do
        boy.stub(:birthday_on?).with(today) { false }

        boy.should_not_receive(:receive)
        subject.send_present
      end
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
      @today = today
    end

    def send_present
      @customer.receive(present) if @customer.birthday_on?(@today)
    end

    private
    def present
      return :cufflinks if @customer.male?
      :flowers
    end
  end
end
