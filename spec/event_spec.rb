require 'spec_helper'

describe Event do
  describe '.current' do
    it 'lists all current events' do
      Event.create({description: "event1", location: "here", start_dt: "mar 30 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
      Event.create({description: "event2", location: "here", start_dt: "mar 26 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
      Event.create({description: "event3", location: "here", start_dt: "mar 29 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
      Event.current[0].description.should eq "event3"
    end
  end
  describe '.day' do
    it 'lists all events for the current day' do
      Event.create({description: "event1", location: "here", start_dt: "mar 30 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
      Event.create({description: "event2", location: "here", start_dt: "mar 27 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
      Event.create({description: "event3", location: "here", start_dt: "mar 29 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
      Event.day[0].description.should eq "event2"
    end
  end
  describe '.week' do
    it 'lists all events for the current week' do
      Event.create({description: "event1", location: "here", start_dt: "mar 30 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
      Event.create({description: "event2", location: "here", start_dt: "mar 27 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
      Event.create({description: "event3", location: "here", start_dt: "mar 29 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
      Event.week.length.should eq 3
    end
  end
  describe '.month' do
    it 'lists all events for the current month' do
      Event.create({description: "event1", location: "here", start_dt: "mar 01 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
      Event.create({description: "event2", location: "here", start_dt: "mar 27 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
      Event.create({description: "event3", location: "here", start_dt: "may 29 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
      Event.month.length.should eq 2
    end
  end
  describe '.previous_day' do
    it 'lists all events for the current month' do
      Event.create({description: "event1", location: "here", start_dt: "mar 26 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
      Event.create({description: "event2", location: "here", start_dt: "mar 27 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
      Event.create({description: "event3", location: "here", start_dt: "may 29 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
      Event.previous_day.length.should eq 1
    end
  end

  it 'validates the presence of a description' do
    event = Event.create({description: "", location: "here", start_dt: "mar 01 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
    event.valid?
    event.errors.should have_key(:description)
  end

  it 'validates the length of a description that is under 20 characters' do
    event = Event.create({description: "1111111111111111111111111", location: "here", start_dt: "mar 01 2014", start_tm: "1pm", end_dt: "mar 29 2014", end_tm: "9pm"})
    event.valid?
    event.errors.should have_key(:description)
  end

end
