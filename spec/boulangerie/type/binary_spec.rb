RSpec.describe Boulangerie::Type::Binary do
  let(:example_string) { "AAAAAAAA".force_encoding("BINARY") }

  describe "#serialize" do
    it "serializes BINARY strings" do
      expect(subject.serialize(example_string)).to eq example_string
    end

    it "raises SerializationError on non-BINARY strings" do
      expect do
        subject.serialize(example_string.force_encoding("UTF-8"))
      end.to raise_error(Boulangerie::SerializationError)
    end
  end

  describe "#deserialize" do
    it "deserializes" do
      expect(subject.deserialize(example_string)).to eq example_string
    end

    it "raises SerializationError on non-BINARY strings" do
      expect do
        subject.deserialize(example_string.force_encoding("UTF-8"))
      end.to raise_error(Boulangerie::SerializationError)
    end
  end
end
