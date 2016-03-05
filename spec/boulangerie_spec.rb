RSpec.describe Boulangerie do
  let(:example_key_id)   { "key1" }
  let(:example_location) { "https://mysupercoolsite.com" }

  let(:example_keys) do
    { example_key_id => "BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA" }
  end

  let(:example_caveats) do
    {
      expires:    Time.now + 5,
      not_before: Time.now
    }
  end

  let(:example_keyring) do
    Boulangerie::Keyring.new(
      keys:     example_keys,
      key_id:   example_key_id
    )
  end

  subject(:boulangerie) do
    described_class.new(
      schema:   fixture_path.join("simple_schema.yml"),
      keyring:  example_keyring,
      location: example_location
    )
  end

  it "raises NotConfiguredError unless configured" do
    expect { described_class.default }.to raise_error(described_class::NotConfiguredError)
  end

  it "initializes from a Schema class instead of a path" do
    boulangerie = described_class.new(
      schema:   Boulangerie::Schema.from_yaml(fixture_path.join("simple_schema.yml").read),
      keyring:  example_keyring,
      location: example_location
    )

    expect(boulangerie).to be_a described_class
  end

  context "minting tokens" do
    it "creates Boulangerie::Macaroons" do
      Timecop.freeze do
        macaroon = boulangerie.create_macaroon(caveats: example_caveats)
        expect(macaroon).to be_a Boulangerie::Macaroon
      end
    end

    it "bakes serialized macaroons as Strings" do
      token = boulangerie.bake(caveats: example_caveats)
      expect(token).to be_a String
    end

    context "undefined predicates" do
      let(:invalid_caveats) do
        {
          derp: Time.now
        }
      end

      it "raises InvalidCaveatError" do
        expect do
          boulangerie.create_macaroon(caveats: example_caveats.merge(invalid_caveats))
        end.to raise_exception(Boulangerie::InvalidCaveatError)
      end
    end
  end

  context "parsing serialized macaroons" do
    let(:example_token) { boulangerie.bake(caveats: example_caveats) }

    it "parses and verifies tokens" do
      macaroon = boulangerie.parse_and_verify(example_token)
      expect(macaroon).to be_a Boulangerie::Macaroon
    end
  end
end
