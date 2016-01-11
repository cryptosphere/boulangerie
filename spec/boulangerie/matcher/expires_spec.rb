RSpec.describe Boulangerie::Matcher::Expires do
  let(:expiration_time) { Time.now }
  let(:valid_time)      { expiration_time - 1 }
  let(:expired_time)    { expiration_time + 1 }

  it "returns true if the current time is before the 'expires' caveat" do
    Timecop.freeze(valid_time) do
      expect(subject.call(expiration_time, nil)).to eq true
    end
  end

  it "returns false if the current time is after the 'expires' caveat" do
    Timecop.travel(expired_time) do
      expect(subject.call(expiration_time, nil)).to eq false
    end
  end
end
