#!/usr/bin/env ruby
# lib/one_time_pad.rb

# Implements a One-Time Pad (OTP) encryption system
# This class provides methods to generate and use a one-time pad for
# message encryption and decryption using ASCII characters (32-126)
#
# @example
#   otp = OneTimePad.new
#   otp.secret = Time.now
#   pad = otp.generate_otp
#   encoded = otp.code(message: "Hello")
#   decoded = otp.decode(message: encoded)
class OneTimePad
  VERSION   = '1.0.0'
  MAX_ROWS  = 2048

  attr_accessor :pad, :secret

  # Initialize a new OneTimePad instance
  #
  # @param secret [Time, nil] Optional time value used for pad generation
  # @param otp [Array<Array<Integer>>, nil] Optional existing pad to use
  # @return [OneTimePad] New instance
  def initialize(
      secret: nil,
      otp:    nil
    )

    @secret = secret

    if otp
      @pad = otp
    end
  end

  # Generates a random seed based on provided UTC time or current time
  #
  # @return [Integer] A random seed value based on time components
  def kaos
    utc = secret.nil? ? Time.now.utc : secret
    utc.year + utc.month + utc.day +
    utc.hour + utc.min   + utc.sec +
    utc.usec
  end

  # Generates a pad of shuffled ASCII codes (32-126)
  #
  # @return [Array<Array<Integer>>] A 2D array of MAX_ROWS rows,
  #   each containing shuffled ASCII codes from 32-126
  def generate_otp
    srand(kaos) # seed the random generator
    ascii_codes = (32..126).to_a
    row_size    = ascii_codes.size
    @pad = Array.new(MAX_ROWS) { ascii_codes.shuffle }
  end


  # Encodes a message using the current pad
  #
  # @param message [String] The message to encode
  # @return [String] The encoded message as a string of ASCII characters
  def code(message:)
    ascii_string = message.encode('ASCII', 
                                  invalid: :replace,
                                  undef:   :replace, 
                                  replace: '_')

    ascii_string.bytes.map.with_index do |byte, i|
      row       = @pad[i % @pad.size]
      char_code = byte.clamp(32, 126)
      row[char_code - 32]
    end.map(&:chr).join
  end

  # Decodes a message using the current pad
  #
  # @param message [String, Array<Integer>] The encoded message
  # @return [String] The decoded message, with invalid characters
  #   replaced by underscores
  def decode(message:)
    encoded = message.is_a?(String) ? message.bytes : message
    encoded.map.with_index do |code, i|
      row        = @pad[i % @pad.size]
      char_index = row.index(code)
      if char_index.nil?
        '_'
      else
        (char_index + 32).chr
      end
    end.join
  end
end

# Main Line
if __FILE__ == $PROGRAM_NAME

  original_message = <<~MESSAGE
    The British are comming!
    The British are comming!
    The British are comming!
    The British are comming!
    They are so pretty in their red coats; however,
    its our job as minute men to shoot them
    down.  Don't fire until you see the whites of their eyes!
    Grab your muskets and hide your women!
    Grab your muskets and hide your women!
    Grab your muskets and hide your women!
    Grab your muskets and hide your women!
    The British are comming!
    The British are comming!
  MESSAGE

  otp         = OneTimePad.new
  otp.secret  = Time.now
  my_code     = otp.generate_otp
  secret      = otp.code(message: original_message)

  puts
  puts secret
  puts "="*65
  puts otp.decode(message: secret)
  puts "="*65
  puts "== Different Instance with otp passed in ..."
  puts
  another = OneTimePad.new(otp: my_code)
  puts another.decode(message: secret)
  puts
end
