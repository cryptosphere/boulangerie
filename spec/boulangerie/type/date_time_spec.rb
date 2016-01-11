RSpec.describe Boulangerie::Type::DateTime do
  let(:example_time) { Time.at(Time.now.to_i) }

  describe "#serialize" do
    it "serializes Time objects" do
      serialized = subject.serialize(example_time)
      expect(Time.iso8601(serialized)).to eq example_time
    end
  end

  describe "#deserialize" do
    it "deserializes" do
      deserialized_time = subject.deserialize(example_time.iso8601)
      expect(deserialized_time).to eq example_time
    end

    it "raises SerializationError if bad characters are present" do
      expect { subject.deserialize("not legit!") }.to raise_error(Boulangerie::SerializationError)
    end
  end
end
