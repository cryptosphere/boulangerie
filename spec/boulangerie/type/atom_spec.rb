RSpec.describe Boulangerie::Type::Atom do
  let(:examples) do
    %w(
      foobar foo-bar-baz foo_bar_baz
      aad7d05a-8699-49d8-9dd2-79f3bf2f7d58
      macaroons.io github.com
      /foo/bar/baz
      42
      BADA55
      mjqxgzjtgi
      3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy
      YmFzZTY0dXJsMDAwXx_32-ab
    )
  end

  describe "#serialize" do
    it "serializes all example labels" do
      examples.each do |example|
        expect(subject.serialize(example)).to eq example
      end
    end

    it "raises SerializationError if bad characters are present" do
      expect { subject.serialize("not legit!") }.to raise_error(Boulangerie::SerializationError)
    end
  end

  describe "#deserialize" do
    it "deserializes all example labels" do
      examples.each do |example|
        expect(subject.deserialize(example)).to eq example
      end
    end
  end
end
