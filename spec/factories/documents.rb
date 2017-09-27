FactoryGirl.define do
  factory :document do
    title 'MyString'
    description 'MyText'
    position 1
    document_file { fixture_file_upload "#{Rails.root}/spec/fixtures/images/product.png", 'image/png' }
    section
  end
end
