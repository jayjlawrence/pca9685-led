require "hmc5883l/version"
require 'i2c_tools'

class Hmc5883l

  class Error < StandardError; end

  include I2cTools

  attr_accessor :samples,

  def register_config_a
    0
  end

  def register_config_b
    1
  end

  def register_mode
    2
  end

  def register_status
    9
  end

  def reading
    result = []
    result << i2c_get_byte(address, 0x03)
    result << i2c_get_byte(address, 0x04)
    result << i2c_get_byte(address, 0x05)
    result << i2c_get_byte(address, 0x06)
    result << i2c_get_byte(address, 0x07)
    result << i2c_get_byte(address, 0x08)
    result
  end

  def reset
    #result_reset = i2c_set_byte(address, 0xfa, 0)
  end


  SAMPLES = [1, 2, 4, 8]

  def set_samples(n=1)
    raise Error.new("samples must be #{SAMPLES}") unless SAMPLES.include?(n)
    @samples = n
    raise Error.new('not done')
  end

  BIAS = [:normal, :positive, :negative]

  def set_measurement_bias(bias = :normal)
    raise Error.new("measurement_bias must be one of #{BIAS}") unless BIAS.include(bias)
    @bias = bias
    raise Error.new('not done')
  end

  # def set_gain(gain)

  def mode_continuous
    result = i2c_set_byte(address, register_mode, 0x0)
  end

  def mode_single_measure
    result = i2c_set_byte(address, register_mode, 0x1)
  end

  def mode_idle
    result = i2c_set_byte(address, register_mode, 0x2)
  end

  def status
    result = i2c_get_byte(address, register_status)
    return :lock if result & 0x02
    return :ready if result & 0x01
    return nil
  end

end
