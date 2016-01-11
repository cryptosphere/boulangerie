RSpec.describe Boulangerie::Verifier do
  let(:example_key_id)   { "key1" }
  let(:example_key)      { "BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA" }
  let(:example_location) { "https://mysupercoolsite.com" }

  let(:example_schema) do
    Boulangerie::Schema.from_yaml(fixture_path.join("simple_schema.yml").read)
  end

  let(:example_caveats) do
    {
      expires:    Time.now + 5,
      not_before: Time.now
    }
  end

  let(:example_macaroon) do
    Boulangerie.new(
      schema:   example_schema,
      keys:     { example_key_id => example_key },
      key_id:   example_key_id,
      location: example_location
    ).create_macaroon(caveats: example_caveats)
  end

  subject(:verifier) { described_class.new(schema: example_schema) }

  describe "#verify" do
    it "verifies against matchers" do
      verifier.verify(
        key:      example_key,
        macaroon: example_macaroon
      )
    end
  end
end
