class GetMyParking

   require_relative "slot"
   attr_accessor :count, :parking_spaces
   def initialize(count)
      @count = 0
      @parking_spaces = []
      count.times do |n|
        @parking_spaces << Slot.new(n)
      end
      @count = @parking_spaces.count
   end

   def park(regno, color)
     #Check available slots and park
     @slot_no=""
     @parking_spaces.each_with_index do |space,index|
       if space.parked_car_regno.empty? && space.parked_car_color.empty?
         space.parked_car_regno = regno
         space.parked_car_color = color
         #comeout of the loop if parked
         @slot_no = (index+1).to_s
         return index+1
         break
       end
     end
     #if no slot available
     if @slot_no.empty?
       return nil
     end
    end

    def leave(slot_no)
      free_slot = @parking_spaces[slot_no-1]
      free_slot.parked_car_regno=""
      free_slot.parked_car_color=""
      return slot_no
    end

    def status
      table = "Slot No  Registration No  Colour"
      @parking_spaces.each_with_index do |space,index|
        reg_no = space.parked_car_regno
        color = space.parked_car_color
        row = (index+1).to_s+"        "+reg_no+"    "+color
        table = table + "\n" + row
      end
      return table
    end

    def registration_numbers_of_cars_with_colour(color)
      cars=""
      @parking_spaces.each_with_index do |space,index|
        if space.parked_car_color == color
          cars = cars+space.parked_car_regno+', '
        end
      end
      return cars
    end

    def slots_for_cars_with_colour(color)
      slots=""
      @parking_spaces.each_with_index do |space,index|
        if space.parked_car_color == color
          slots = slots+(index+1).to_s+', '
        end
      end
      return slots
    end

    def slot_for_registration_number(reg_no)
      slot=""
      @parking_spaces.each_with_index do |space,index|
        if space.parked_car_regno == reg_no
          slot = (index+1).to_s
        end
      end
      return !slot.empty? ? slot : 'Not Found'
    end
end

loop do
  mode_type = ARGV.first
  if mode_type
  # ------------------------------Code for File mode type---------------------------
    if mode_type == "file_inputs.txt > output.txt"
      input_file = mode_type.split(">")[0].strip
      output_file = mode_type.split(">")[1].strip
      @input_file_path = "#{Dir.pwd}/processed_data/#{input_file}"
      @output_file_path = "#{Dir.pwd}/processed_data/#{output_file}"

      if File.file?(@input_file_path) && File.file?(@output_file_path)
        #Clear Output File
        open_output_file = File.open(@output_file_path, "a+")
        open_output_file.truncate(0)
        #Parse Input File
        File.open(@input_file_path, "r") do |file|
          while input_command = file.gets
            unless input_command.empty?
              @input_command = input_command
              command, *params = @input_command.split /\s/
              case command
                when 'create_parking_garage'
                  $parking_lot = GetMyParking.new params[0].to_i
                  output = "Created a parking garage with #{params[0].to_i} slots"
                  # puts p.parking_spaces[slotno]
                when 'park'
                  @slot_no = $parking_lot.park params[0], params[1]
                  if !@slot_no.nil?
                    output = "Car parked at slot: #{@slot_no}"
                  else
                    output = "No parking space available"
                  end
                when 'leave'
                  @slot_no = $parking_lot.leave params[0].to_i
                  output = "Slot number #{@slot_no} is free"
                when 'status'
                  output = $parking_lot.status
                when 'registration_numbers_of_cars_with_colour'
                  output = $parking_lot.registration_numbers_of_cars_with_colour params[0]
                when 'slots_for_cars_with_colour'
                  output = $parking_lot.slots_for_cars_with_colour params[0]
                when 'slot_for_registration_number'
                  output = $parking_lot.slot_for_registration_number params[0]
                else
                  output = 'Invalid command'
              end
              open_output_file.write output
              open_output_file.write "\n"
            end
          end
        end
        puts '------------------------------------------------------'
        puts 'OUTPUT_FILE GENERATED SUCCESSFULLY'
        puts 'FIND OUT FILE IN DATA DIRECTORY'
      else
        puts 'Wrong Input file or Output file provided'
      end
    else
      puts 'Wrong Input file or Output file provided'
    end
    break
  else
    #---------------------------Code for Interactive Shell--------------------------

    input = STDIN.gets.strip
    command, *params = input.split /\s/
    case command
      when 'create_parking_garage'
        $parking_lot = ParkingLot.new params[0].to_i
        # puts $parking_lot.count
        # puts p.parking_spaces[slotno]
        puts "Created a parking garage with #{params[0].to_i} slots"
      when 'park'
        @slot_no = $parking_lot.park params[0], params[1]
        if !@slot_no.nil?
          puts "Car parked at slot: #{@slot_no}"
        else
          puts "No parking space available"
        end
      when 'leave'
        @slot_no = $parking_lot.leave params[0].to_i
        puts "Slot number #{@slot_no} is free"
      when 'leave'
        @slot_no = $parking_lot.leave params[0].to_i
        puts "Slot number #{@slot_no} is free"
      when 'status'
        puts $parking_lot.status
      when 'registration_numbers_of_cars_with_colour'
        puts $parking_lot.registration_numbers_of_cars_with_colour params[0]
      when 'slots_for_cars_with_colour'
        puts $parking_lot.slots_for_cars_with_colour params[0]
      when 'slot_for_registration_number'
        puts $parking_lot.slot_for_registration_number params[0]
      else
        puts 'Invalid command'
    end
  end
end
