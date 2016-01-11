RSpec.describe Boulangerie::Matcher::NotBefore do
  let(:not_before_time) { Time.now }
  let(:too_early_time)  { not_before_time - 1 }
  let(:valid_time)      { not_before_time + 1 }

  it "returns true if the current time is after the 'not-before' caveat" do
    Timecop.freeze(valid_time) do
      expect(subject.call(not_before_time, nil)).to eq true
    end
  end

  it "returns false if the current time is before the 'not-before' caveat" do
    Timecop.travel(too_early_time) do
      expect(subject.call(not_before_time, nil)).to eq false
    end
  end
end
