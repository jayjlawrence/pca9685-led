require "Pca9685/version"
require 'i2c_tools'

class Pca9685

  class Error < StandardError; end

  include I2cTools

  attr :addr

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

  #def reset
  #  execute ["/usr/sbin/i2cset", "-y", "1", hexb(@addr), hexb(register_mode2), hexb(0x04), 'b'].join(' ')
  #  mode_normal
  #end


  #def mode_sleep
  #  execute ["/usr/sbin/i2cset", "-y", "1", "-m", "0x10", hexb(@addr), hexb(register_mode1), hexb(0x10), 'b'].join(' ')
  #end

  #def mode_normal
  #  execute ["/usr/sbin/i2cset", "-y", "1", "-m", "0x10", hexb(@addr), hexb(register_mode1), hexb(0x00), 'b'].join(' ')
  #end

  #def led_all(intensity)
  #end

  def led_set(led = 0, intensity = 0)
    value_on, value_off = led_on_off(led, intensity)
    puts ["led", led, "intensity", intensity, "led on", value_on, "led off", value_off].join(' ')
    i2c_set_word(1, @addr, led_register_on, value_on)
    i2c_set_word(1, @addr, led_register_off, value_off)
  end

  def freq_set(freq)
    mode_sleep
    pre_scale = (25000000 / 4096 * freq).to_i - 1
    mode_normal
  end

end
