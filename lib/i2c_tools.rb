require 'mixlib/shellout'

module I2cTools
  attr_accessor :debug, :dryrun, :logger

  def hexb(val)
    sprintf "0x%02x", val
  end

  def hexw(val)
    t = sprintf "%04x", val
    "0x#{t[0..3].upcase}"
    #"0x#{t[2..3]}#{t[0..1]}"
  end

  def i2c_set_word(bus=1, addr, register, value)
    i2c_cmd=Mixlib::ShellOut.new("/usr/sbin/i2cset", "-y", bus.to_s, hexb(addr), hexb(register), hexw(value), 'w', timeout: 2)
    i2c_cmd.logger(logger) if logger
    STDERR.puts i2c_cmd.command if debug
    unless dryrun
      i2c_cmd.run_command
      if i2c_cmd.error!
        STDERR.puts i2c_cmd.stdout
        STDERR.puts i2c_cmd.stderr
      end
    end
    dryrun || !i2c_cmd.error! ? i2c_cmd.command : nil
  end

end