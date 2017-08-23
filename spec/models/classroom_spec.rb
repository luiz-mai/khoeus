require 'rails_helper'

RSpec.describe Classroom, type: :model do
  let(:classroom) { build :classroom }
  let(:no_grades) { build :no_grades }

  it 'is valid with valid parameters' do expect(classroom).to be_valid end

  it { should have_secure_password }
  it { should validate_presence_of :name }
  it { should validate_presence_of :password }

  context 'when has grades' do
    before { allow(subject).to receive(:has_grades?).and_return(true) }
    it { should validate_presence_of(:minimum_grade) }
  end
  context 'when doesnt have grades' do
    before { allow(subject).to receive(:has_grades?).and_return(false) }
    it { should_not validate_presence_of(:minimum_grade) }
  end

  it { should have_many(:users).through :subscriptions }

end
