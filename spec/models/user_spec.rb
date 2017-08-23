require 'rails_helper'

describe User, type: :model do
  let!(:user) { build :user }
  subject { FactoryGirl.build(:user) }
  
  it 'is valid with valid parameters' do expect(user).to be_valid end
  it { should validate_presence_of(:name)}
  it { should validate_presence_of(:email)}
  it { should_not allow_value('aaa@gmail').for(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_length_of(:password).is_at_least(8)}
  it { should validate_confirmation_of(:password) }
  it { should validate_presence_of(:cep)}
  it { should validate_numericality_of(:cep).only_integer }
  it { should validate_length_of(:cep).is_equal_to(8) }
  it { should validate_presence_of(:address)}
  it { should validate_presence_of(:number)}
  it { should validate_numericality_of(:number).only_integer }
  it { should validate_presence_of(:neighborhood)}
  it { should validate_presence_of(:city)}
  it { should validate_presence_of(:state)}
  it { should validate_presence_of(:country)}

end
