require 'mixlib/shellout'

module I2cTools

  class << self
    attr_accessor :debug, :dryrun, :logger
  end

  def hexb(val)
    sprintf "0x%02x", val
  end

  def hexw(val)
    t = sprintf "%04x", val
    "0x#{t[0..3]}"
  end

  def i2c_set_word(bus = 1, addr, register, value)
    i2c_cmd = Mixlib::ShellOut.new("/usr/sbin/i2cset", "-y", bus.to_s, hexb(addr), hexb(register), hexw(value), 'w', timeout: 2)
    i2c_cmd.logger(logger) if self.logger
    STDERR.puts i2c_cmd.command.join(' ') if self.debug
    unless self.dryrun
      i2c_cmd.run_command
      if i2c_cmd.error!
        STDERR.puts "Error running i2c command"
        STDERR.puts i2c_cmd.stdout
        STDERR.puts i2c_cmd.stderr
      end
    end
    self.dryrun || !i2c_cmd.error! ? i2c_cmd.command : nil
  end

  def i2c_set_byte(bus = 1, addr, register, value)
    i2c_cmd = Mixlib::ShellOut.new("/usr/sbin/i2cset", "-y", bus.to_s, hexb(addr), hexb(register), hexb(value), 'b', timeout: 2)
    i2c_cmd.logger(logger) if self.logger
    STDERR.puts i2c_cmd.command.join(' ') if self.debug
    unless self.dryrun
      i2c_cmd.run_command
      if i2c_cmd.error!
        STDERR.puts "Error running i2c command"
        STDERR.puts i2c_cmd.stdout
        STDERR.puts i2c_cmd.stderr
      end
    end
    self.dryrun || !i2c_cmd.error! ? i2c_cmd.command : nil
  end

  def i2c_set_lh_bytes(bus = 1, addr, register, value)
    low = value % 256
    high = (value - low) / 256
    i2c_set_byte(bus, addr, register, low)
    i2c_set_byte(bus, addr, register+1, high)
  end

end