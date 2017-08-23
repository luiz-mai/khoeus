FactoryGirl.define do

  factory :classroom, class: Classroom do
    name 'Classroom A'
    password 'testpassword'
    password_digest '$2a$10$Yu4K755h7Hy3TUKyXutgPO5zjgj0APPfZSEm/Ygnm8Z4hvAQhQJwu'
    has_grades true
    has_attendance true
    minimum_grade 7.0

    factory :no_grades do
      has_grades false
    end

    factory :no_attendance do
      has_attendance false
    end
  end
end
