RSpec.describe Boulangerie::Schema do
  it "generates random schema-ids" do
    expect(described_class.create_schema_id).to match(/\h{16}/)
  end

  context "valid schema" do
    let(:example_schema_file) { fixture_path + "example_schema.yml" }
    let(:example_schema_id)   { "ee6da70e5ba01fec" }

    it "loads schemas from YAML files" do
      schema = described_class.from_yaml(example_schema_file.read)

      expect(schema.schema_id).to eq example_schema_id
      expect(schema.current_version).to eq 1
    end
  end

  context "invalid schemas" do
    describe "missing schema-id" do
      let(:example_schema_file) { fixture_path + "unidentified_schema.yml" }

      it "raises InvalidSchemaIdError" do
        expect do
          described_class.from_yaml(example_schema_file.read)
        end.to raise_error(Boulangerie::Schema::InvalidSchemaIdError)
      end
    end

    describe "non-sequential version numbers" do
      let(:example_schema_file) { fixture_path + "badly_versioned_schema.yml" }

      it "raises InvalidVersionError" do
        expect do
          described_class.from_yaml(example_schema_file.read)
        end.to raise_error(Boulangerie::Schema::InvalidVersionError)
      end
    end

    describe "invalid types" do
      let(:example_schema_file) { fixture_path + "badly_typed_schema.yml" }

      it "raises InvalidTypeError" do
        expect do
          described_class.from_yaml(example_schema_file.read)
        end.to raise_error(Boulangerie::Schema::InvalidTypeError)
      end
    end

    describe "unrecognized toplevel keys" do
      let(:example_schema_file) { fixture_path + "invalid_keys_schema.yml" }

      it "raises ParseError" do
        expect do
          described_class.from_yaml(example_schema_file.read)
        end.to raise_error(Boulangerie::Schema::ParseError)
      end
    end

    describe "duplicate predicates" do
      let(:example_schema_file) { fixture_path + "duplicate_predicate_schema.yml" }

      it "raises ParseError" do
        expect do
          described_class.from_yaml(example_schema_file.read)
        end.to raise_error(Boulangerie::Schema::ParseError)
      end
    end
  end
end
