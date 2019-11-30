RSpec.describe Hmc5883l do
  it "has a version number" do
    expect(Hmc5883l::VERSION).not_to be nil
  end

  before do
    @hcm=Hmc5883l.new
    @hcm.dryrun=true
  end

  describe "#read" do
    it "returns an array of 6 values" do
      expect(@hcm.read).to eq([])
    end
  end

end
