RSpec.describe Boulangerie::Type::Boolean do
  describe "#serialize" do
    it "serializes TrueClass" do
      expect(subject.serialize(true)).to eq "true"
    end

    it "serializes FalseClass" do
      expect(subject.serialize(false)).to eq "false"
    end

    it "serializes NilClass" do
      expect(subject.serialize(nil)).to eq "false"
    end
  end

  describe "#deserialize" do
    it "deserializes 'true'" do
      expect(subject.deserialize("true")).to eq true
    end

    it "deserializes 'false'" do
      expect(subject.deserialize("false")).to eq false
    end

    it "raises SerializationError on other strings" do
      expect { subject.deserialize("truthy") }.to raise_error(Boulangerie::SerializationError)
    end
  end
end
