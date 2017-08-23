FactoryGirl.define do

  factory :subscription do
    user
    classroom

    factory :teacher_subscription do
      role 'teacher'
    end
    factory :student_subscription do
      role 'student'
    end
  end

end