require 'rails_helper'

describe 'the user registration', :type => :feature do
  let(:user) {build :user}

  context 'when fills the form with valid parameters' do
    before(:each) do
      visit '/signup'
      within('#new_user') do
        fill_in 'user_name', with: user.name
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        fill_in 'user_password_confirmation', with: user.password
        fill_in 'user_cep', with: user.cep
        fill_in 'user_address', with: user.address
        fill_in 'user_number', with: user.number
        fill_in 'user_neighborhood', with: user.neighborhood
        fill_in 'user_city', with: user.city
        fill_in 'user_state', with: user.state
        fill_in 'user_country', with: user.country
      end
    end

    it 'creates the user' do
      click_button 'Cadastrar'
      expect(User.find_by(email: user.email)).to_not be_nil
    end
    it 'sends the activation email' do
      expect do
        click_button 'Cadastrar'
      end.to change {ActionMailer::Base.deliveries.size}.by(1)
    end
    it 'asks for activation' do
      click_button 'Cadastrar'
      expect(page).to have_content 'Please, check your email to activate your account.'
    end
  end

  context 'when fills the form with invalid parameters' do
    before(:each) do
      visit '/signup'
      within('#new_user') do
        fill_in 'user_name', with: user.name
        fill_in 'user_email', with: 'invalid@email'
        fill_in 'user_password', with: user.password
        fill_in 'user_password_confirmation', with: user.password
        fill_in 'user_cep', with: user.cep
        fill_in 'user_address', with: user.address
        fill_in 'user_number', with: user.number
        fill_in 'user_neighborhood', with: user.neighborhood
        fill_in 'user_city', with: user.city
        fill_in 'user_state', with: user.state
        fill_in 'user_country', with: user.country
      end
      click_button 'Cadastrar'
    end

    it 'shows error message' do
      expect(page).to have_selector(:css, '.alert-danger')
    end
  end

end