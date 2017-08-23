require 'rails_helper'

describe 'the password reset', :type => :feature do
  let(:user) {create :user}
  let(:confirmed_user) {create :confirmed_user}

  context 'when user requests with an existing email' do
    before(:each) do
      visit '/password-reset'
      fill_in 'user_email', with: confirmed_user.email
    end

    it 'sends the email' do
      expect do
        click_button 'Enviar'
      end.to change {ActionMailer::Base.deliveries.size}.by(1)
    end

    it 'tells the user to check email' do
      click_button 'Enviar'
      expect(page).to have_content 'Email sent with password reset instructions'
    end
  end

  context 'when user requests with non existing email' do
    before(:each) do
      visit '/password-reset'
      fill_in 'user_email', with: 'non-existing@gmail.com'
      click_button 'Enviar'
    end

    it 'tells the user the email doesnt exist' do
      expect(page).to have_content 'Email address not found'
    end
  end

  context 'when user chooses a valid password' do
    before(:each) do
      visit "/password-reset/#{confirmed_user.reset_token}?email=#{confirmed_user.email}"
      fill_in 'user_password', with: '1111111111'
      fill_in 'user_password_confirmation', with: '1111111111'
      click_button 'Update password'
    end

    it 'changes the password' do
      confirmed_user.reload
      expect(confirmed_user.authenticate('1111111111')).to be_truthy
    end

    it 'tells the user the password was changed' do
      expect(page).to have_content 'Password has been reset'
    end
  end

  context 'when user chooses an invalid password' do
    before(:each) do
      visit "/password-reset/#{confirmed_user.reset_token}?email=#{confirmed_user.email}"
      fill_in 'user_password', with: '123'
      fill_in 'user_password_confirmation', with: '123'
      click_button 'Update password'
    end

    it 'changes the password' do
      expect(page).to have_selector('.alert-danger')
    end
  end


end