RSpec.describe Boulangerie do
  let(:example_key_id) { "key1" }

  let(:example_keys) do
    { example_key_id => "totally secret key I swear" }
  end

  it "initializes a default Boulangerie" do
    expect { described_class.default }.to raise_error(described_class::NotConfiguredError)

    described_class.setup(
      schema: fixture_path.join("example_schema.yml"),
      keys:   example_keys,
      key_id: example_key_id
    )

    expect(described_class.default).to be_a described_class
  end
end
