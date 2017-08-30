require 'rails_helper'

RSpec.describe Section, type: :model do

  it { should validate_presence_of :title }
  it { should validate_presence_of :position }
  it { should belong_to :classroom }

end
