require "pca9685/version"
require 'i2c_tools'

class Pca9685

  class Error < StandardError; end

  include I2cTools

  def register_mode1
    0
  end

  def register_mode2
    1
  end

  def register_led_on(led = 0)
    (led.to_i) * 4 + 6
  end

  def register_led_off(led = 0)
    register_led_on(led) + 2
  end

  LED_DELAY=4096/16
  def led_on_off(led, intensity)
    raise Error.new if intensity < 0 or intensity > 4095
    delay = led * LED_DELAY
    [delay, (delay + intensity)%4096]
  end

  def reset(address)
    result_reset = i2c_set_byte(address, 0xfa, 0)
    result_reset = i2c_set_byte(address, 0xfb, 0)
    result_reset = i2c_set_byte(address, 0xfc, 0)
    result_reset = i2c_set_byte(address, 0xfd, 0)
    result_reset = i2c_set_byte(address, register_mode2, 0x04)
    result_reset = i2c_set_byte(address, register_mode1, 0x01)
    result_reset = i2c_set_byte(address, register_mode1, 0x01)
  end


  def mode_sleep(address)
    result_sleep = i2c_set_byte(address, register_mode1, 0x11)
  end

  def mode_normal(address)
    result_sleep = i2c_set_byte(address, register_mode1, 0x01)
    result_sleep = i2c_set_byte(address, register_mode1, 0x81)
  end

  #def led_all(intensity)
  #end

  def led_set(led:, intensity:, address:)
    value_on, value_off = led_on_off(led, intensity)
    # puts ["address", address, "led", led, "intensity", intensity, "led on", value_on, "led off", value_off].join(' ')
    result_on = i2c_set_lh_bytes(address, register_led_on(led), value_on)
    result_off = i2c_set_lh_bytes(address, register_led_off(led), value_off)
    result_on && result_off
  end

  def freq_set(address, freq)
    mode_sleep(address)
    result_sleep = i2c_set_byte(address, 0xfe, 0x65)
    mode_normal(address)
  end

end
