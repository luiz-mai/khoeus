require 'rails_helper'

describe 'the user registration', :type => :feature do
  let(:user) {create :user}
  let(:confirmed_user) {create :confirmed_user}

  context 'when user is confirmed' do
    before(:each) do
      visit '/login'
      fill_in 'login_email', with: confirmed_user.email
      fill_in 'login_password', with: confirmed_user.password
      click_button 'Entrar'
    end

    it 'logs the user in' do
      expect(page).to have_content confirmed_user.name
    end
  end

  context 'when user is not confirmed' do
    before(:each) do
      visit '/login'
      fill_in 'login_email', with: user.email
      fill_in 'login_password', with: user.password
      click_button 'Entrar'
    end

    it 'logs the user in' do
      expect(page).to have_content 'Account not activated'
    end
  end

  context 'when filling with invalid params' do
    before(:each) do
      visit '/login'
      fill_in 'login_email', with: 'aaaa@gmail'
      fill_in 'login_password', with: user.password
      click_button 'Entrar'
    end

    it 'shows error message' do
      expect(page).to have_selector('.alert-danger')
    end
  end
end