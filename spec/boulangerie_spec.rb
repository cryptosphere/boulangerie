RSpec.describe Boulangerie do
  let(:example_key_id)   { "key1" }
  let(:example_location) { "https://mysupercoolsite.com" }

  let(:example_keys) do
    { example_key_id => "BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA" }
  end

  it "raises NotConfiguredError unless configured" do
    expect { described_class.default }.to raise_error(described_class::NotConfiguredError)
  end

  it "initializes a default Boulangerie" do
    boulangerie = described_class.new(
      schema:   fixture_path.join("example_schema.yml"),
      keys:     example_keys,
      key_id:   example_key_id,
      location: example_location
    )

    expect(boulangerie).to be_a described_class
  end

  it "initializes from a Schema class instead of a path" do
    boulangerie = described_class.new(
      schema:   Boulangerie::Schema.from_yaml(fixture_path.join("example_schema.yml").read),
      keys:     example_keys,
      key_id:   example_key_id,
      location: example_location
    )

    expect(boulangerie).to be_a described_class
  end

  context "minting tokens" do
    let(:example_caveats) do
      {
        expires:    Time.now + 5,
        not_before: Time.now
      }
    end

    let(:boulangerie) do
      described_class.new(
        schema:   fixture_path.join("simple_schema.yml"),
        keys:     example_keys,
        key_id:   example_key_id,
        location: example_location
      )
    end

    it "creates Macaroons" do
      Timecop.freeze do
        macaroon = boulangerie.create_macaroon(caveats: example_caveats)

        expect(macaroon).to be_a Boulangerie::Macaroon
        expect(macaroon.location).to eq example_location

        # TODO: verify predicates
      end
    end

    it "bakes cookies as strings" do
      cookie = boulangerie.bake(caveats: example_caveats)
      expect(cookie).to be_a String
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
end
