require 'rails_helper'

RSpec.describe Document, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :position }
  it { should validate_numericality_of :position }
  it { should validate_presence_of :document_file }
  it { should belong_to :section }
end
