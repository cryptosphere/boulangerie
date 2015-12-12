RSpec.describe Boulangerie::Keyring do
  let(:default_key_id) { "k1" }

  let(:example_keys) do
    {
      "k0" => "DEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEF",
      "k1" => "BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA"
    }
  end

  let(:example_keyring) { described_class.new(example_keys, key_id: default_key_id) }

  it "raises ArgumentError if key_id is not in the keyring" do
    expect do
      described_class.new(example_keys, key_id: "lalala")
    end.to raise_error(ArgumentError)
  end

  it "raises ArgumentError if a key is too short" do
    expect do
      described_class.new({ default_key_id => "derp" }, key_id: default_key_id)
    end.to raise_error(ArgumentError)
  end

  it "generates keys" do
    expect(described_class.generate_key).to match(/\h{64}/)
  end

  it "does not include keys in #inspect" do
    example_keys.each do |_kid, key|
      expect(example_keyring.inspect).to_not include(key)
    end
  end

  it "does not include keys in #to_s" do
    example_keys.each do |_kid, key|
      expect(example_keyring.to_s).to_not include(key)
    end
  end
end
