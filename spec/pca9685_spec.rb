RSpec.describe Pca9685 do
  it "has a version number" do
    expect(Pca9685::VERSION).not_to be nil
  end

  before do
    @pca=Pca9685.new
    @pca.dryrun=true
  end

  describe "#register_led_on" do
    it "produces correct register for on led 0" do
      expect(@pca.register_led_on(0)).to eq(6)
    end
    it "produces correct register for on led 1" do
      expect(@pca.register_led_on(1)).to eq(10)
    end
  end

  describe "#register_led_off" do
    it "produces correct register for off led 0" do
      expect(@pca.register_led_off(0)).to eq(8)
    end
    it "produces correct register for off led 1" do
      expect(@pca.register_led_off(1)).to eq(12)
    end
  end

  describe "#led_on_off" do
    it "is correct for led 0 intensity 0" do
      expect(@pca.led_on_off(0,0)).to eq([0,0])
    end
    it "is correct for led 0 intensity 1" do
      expect(@pca.led_on_off(0,1)).to eq([0,1])
    end
    it "is correct for led 0 intensity 4095" do
      expect(@pca.led_on_off(0,4095)).to eq([0,4095])
    end
    it "is correct for led 1 intensity 0" do
      expect(@pca.led_on_off(1,0)).to eq([256,256])
    end
    it "is correct for led 1 intensity 1" do
      expect(@pca.led_on_off(1,1)).to eq([256,257])
    end
    it "is correct for led 1 intensity 4095" do
      expect(@pca.led_on_off(1,4095)).to eq([256,255])
    end
    it "is correct for led 15 intensity 0" do
      expect(@pca.led_on_off(15,0)).to eq([3840,3840])
    end
    it "is correct for led 15 intensity 1" do
      expect(@pca.led_on_off(15,1)).to eq([3840,3841])
    end
    it "is correct for led 15 intensity 4095" do
      expect(@pca.led_on_off(15,4095)).to eq([3840,3839])
    end
    it "throws an exception if intensity is -1" do
      expect {@pca.led_on_off(0,-1)}.to raise_error(Pca9685::Error)
    end
    it "throws an exception if intensity is 4096" do
      expect {@pca.led_on_off(0,4096)}.to raise_error(Pca9685::Error)
    end
  end

  describe "#i2c_set_word" do
    it "makes a valid shell command for intensity 0" do
      expect(@pca.i2c_set_word(1, 0x40, 0x06, 0)).to eq( ["/usr/sbin/i2cset", "-y", "1", "0x40", "0x06", "0x0000", "w"])
    end
    it "makes a valid shell command for intensity 1" do
      expect(@pca.i2c_set_word(1, 0x40, 0x06, 1)).to eq( ["/usr/sbin/i2cset", "-y", "1", "0x40", "0x06", "0x0001", "w"])
    end
    it "makes a valid shell command for intensity 4095" do
      expect(@pca.i2c_set_word(1, 0x40, 0x06, 4095)).to eq( ["/usr/sbin/i2cset", "-y", "1", "0x40", "0x06", "0x0FFF", "w"])
    end
  end
end
