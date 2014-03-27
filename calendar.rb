require 'bundler/setup'
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["development"])


def welcome
  puts "Welcome to your calendar!"
  puts "========================="
  main
end

def main
  puts "Enter [1] to add a new event"
  puts "      [2] to list all current events"
  puts "      [3] to list todays events"
  puts "      [4] to list events by week"
  puts "      [5] to list events by month"
  puts "      [6] to edit an event"
  puts "      [7] to delete an event"
  puts "      [8] to exit\e[0m"
  choice = nil
  until choice == '5'
    choice = gets.chomp
    case choice
    when '1'
      add_event
    when '2'
      clear
      @event_array = Event.current
      list_event
      main
    when '3'
      clear
      @type = "day"
      @event_array = Event.day
      list_event
      prev_next
    when '4'
      clear
      @type = "week"
      @event_array = Event.week
      list_event
    when '5'
      clear
      @type = "month"
      @event_array = Event.month
      list_event
    when '6'
      clear
      @event_array = Event.current
      list_event
      edit_event
    when '7'
      clear
      @event_array = Event.current
      list_event
      delete_event
    when '8'
      clear
      puts "Goodbye"
      exit
    else
      clear
      puts "Invalid input."
      main
    end
  end
end

def add_event
  puts "Name of new event:"
  desc = gets.chomp
  puts "Location of event:"
  location = gets.chomp
  puts "Starting date:"
  start_dt = gets.chomp
  puts "Starting time:"
  start_tm = gets.chomp
  puts "Ending date:"
  end_dt = gets.chomp
  puts "Ending time:"
  end_tm = gets.chomp

  event = Event.new({description: desc, location: location,
                     start_dt: start_dt, start_tm: start_tm,
                     end_dt: end_dt, end_tm: end_tm})
  if event.save
    puts "'#{desc}' has been added."
    clear
    add_another("add_event")
  else
    clear
    event.errors.full_messages.each { |message| puts "\e[5;31m"+message+"\e[0;0m" }
    puts "\n"
    main
  end
end

def add_another(method_name)
  puts "Would you like to add another (y/n)?"
  user_input = gets.chomp
  if user_input == 'y'
    clear
    list_event
    method(method_name).call
  else
    clear
    main
  end
end

def list_event
  puts "Here is a list of events from your calendar:"
  puts '=================================================================================='
  puts "\e[36mDescription         Location       Start Date & Time  -  End Date &   Time   ID"
  puts '----------------------------------------------------------------------------------'
  @event_array.each_with_index do |event, index|
    puts "#{event.description}" + " "*(20-event.description.length) +
         "#{event.location}" + " "*(15-event.location.length) +
         "#{event.start_dt.strftime("%b %d, %y")}" + " "*(13-event.start_dt.to_s.length) +
         "#{event.start_tm.strftime("%H:%M")} -" + " "*(24-event.start_tm.to_s.length) +
         " #{event.end_dt.strftime("%b %d, %y")}" + " "*(13-event.end_dt.to_s.length) +
         "#{event.end_tm.strftime("%H:%M")}" + "   " + "#{index+1}"
   end
  puts "\e[0m"
end

def edit_event
  puts "Select the event by ID that you would like to edit."
  user_input = gets.chomp.to_i
  @current_event = @event_array[user_input-1]
  puts "Choose what you would like to edit by number."
  list_columns(@event_array)
  column_choice = gets.chomp.to_i
  puts "Enter the updated information:"
  update = gets.chomp
  column = @table_columns[column_choice-1]
  @current_event.update({:"#{column}" => update})
  puts "#{@current_event.description} has had the #{column} updated"
  clear
  main
end

def list_columns(table_all)
  @table_columns = table_all.column_names - %w(id created_at updated_at)
  @table_columns.each_with_index do |table_column, index|
    puts "#{index+1}. #{table_column}"
  end
end

def delete_event
  puts "Select the event by ID that you would like to delete."
  user_input = gets.chomp.to_i
  @event_array[user_input-1].destroy
  clear
  puts "Event removed from your calendar."
  main
end

def prev_next
  puts "Select [p]revious to see the previous or"
  puts "       [n]ext to see the next"
  puts "       [b]ack to go to main menu"
  case gets.chomp
  when 'p'
    clear
    something = "previous_" + @type
    @event_array = Event.method(something).call
    binding.pry
    list_event
  when 'n'

  when 'b'

  else
    clear
    puts "Invalid input"
    prev_next
  end
end
















def clear
  system "clear && printf '\e[3J'"
end

clear
welcome
