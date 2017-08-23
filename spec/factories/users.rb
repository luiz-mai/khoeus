FactoryGirl.define do

  factory :user, class: User do
    name 'Luiz Mai'
    email 'luiz@gmail.com'
    password '11111111'
    password_confirmation '11111111'
    cep '11111111'
    address 'Rua X'
    number '4'
    complement 'complemento'
    neighborhood 'aaaa'
    city 'vitoria'
    state 'ES'
    country 'Brasil'
    #photo_name
    #language
    #timezone
    admin false
    #last_access
    reset_token 'X-z0Ff6d2sAeULCIqOddrw'
    reset_sent_at { 1.hour.ago }
    reset_digest '$2a$10$P5Y6ZLleOWf4ppvvPkFQFu3LUP7yrhxrjgpkpDBqJEeM94n7XljqG'

    factory :other_user, class: User do
      id 2
      email 'other@gmail.com'
    end

    factory :invalid_user, class: User do
      id 3
      email nil
    end

    factory :admin_user, class: User do
      id 4
      email 'admin@gmail.com'
      admin true
    end

    factory :confirmed_user, class: User do
      id 5
      email 'confirmed@gmail.com'
      confirmed true
      confirmed_at { 1.days.ago }
    end

    factory :unconfirmed_user, class: User do
      id 6
      email 'unconfirmed@gmail.com'
      confirmed false
      confirmed_at nil
    end

    factory :expired_token_user, class: User do
      id 7
      email 'expired@gmail.com'
      reset_sent_at { 1.day.ago }
      confirmed true
      confirmed_at { 1.days.ago }
    end
  end
end