# frozen_string_literal: true

require_relative "test_helper"

class TestOneTimePad < Minitest::Test
  def setup
    @otp        = OneTimePad.new
    @secret     = Time.utc(2023, 1, 1, 12, 0, 0)
    @otp.secret = @secret
  end

  def test_that_it_has_a_version_number
    refute_nil OneTimePad::VERSION
  end

  def test_initialize_with_default_values
    otp = OneTimePad.new
    assert_nil otp.secret
    assert_nil otp.pad
  end

  def test_initialize_with_custom_values
    custom_pad = Array.new(OneTimePad::MAX_ROWS) { (32..126).to_a }
    otp = OneTimePad.new(secret: @secret, otp: custom_pad)
    assert_equal @secret, otp.secret
    assert_equal custom_pad, otp.pad
  end

  def test_kaos_generates_consistent_seed
    expected_seed = 2023 + 1 + 1 + 12 + 0 + 0 + 0
    assert_equal expected_seed, @otp.kaos
  end

  def test_generate_otp_creates_valid_pad
    @otp.generate_otp
    assert_equal OneTimePad::MAX_ROWS, @otp.pad.size
    @otp.pad.each do |row|
      assert_equal 95, row.size
      assert_equal (32..126).to_a.sort, row.sort
    end
  end

  def test_code_encodes_message
    @otp.generate_otp
    message = "Hello, World!"
    encoded = @otp.code(message: message)
    refute_equal message, encoded
    assert_equal message.length, encoded.length
  end

  def test_decode_decodes_message
    @otp.generate_otp
    message = "Hello, World!"
    encoded = @otp.code(message: message)
    decoded = @otp.decode(message: encoded)
    assert_equal message, decoded
  end

  def test_code_and_decode_with_non_ascii_characters
    @otp.generate_otp
    message = "Hello, 世界!"
    encoded = @otp.code(message: message)
    decoded = @otp.decode(message: encoded)
    assert_equal "Hello, __!", decoded
  end

  def test_decode_with_invalid_characters
    @otp.generate_otp
    invalid_message = [0, 255, 127].pack('C*')
    decoded         = @otp.decode(message: invalid_message)
    assert_equal "___", decoded
  end
end

