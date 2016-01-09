RSpec.describe Boulangerie::Type::URI do
  let(:examples) do
    %w(
      so.generic:thing
      https://www.example.com
    )
  end

  describe "#serialize" do
    it "serializes all example labels" do
      examples.each do |example|
        expect(subject.serialize(example)).to eq example
      end
    end

    it "raises SerializationError if bad characters are present" do
      expect { subject.serialize("not legit!") }.to raise_error(URI::InvalidURIError)
    end
  end

  describe "#deserialize" do
    it "deserializes all example labels" do
      examples.each do |example|
        expect(subject.deserialize(example)).to eq URI(example)
      end
    end
  end
end
