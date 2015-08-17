RSpec.describe Boulangerie::Schema do
  let(:example_schema_file) { fixture_path + "example_schema.yml" }

  it "loads schemas from YAML files" do
    schema = described_class.from_yaml(example_schema_file.read)

    expect(schema.predicates["time_after"]).to be_a Boulangerie::Predicates::TimeAfter
    expect(schema.predicates["time_before"]).to be_a Boulangerie::Predicates::TimeBefore
  end
end
