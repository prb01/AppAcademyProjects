require 'spec_helper'
require 'rails_helper'

feature 'the signup process' do
  scenario 'has a new user page' do
    visit new_user_url

    expect(page).to have_content 'Sign up'
  end

  feature 'signing up a user' do
    let(:user) { FactoryBot.build(:user) }

    before(:each) do
      visit new_user_url
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_on 'Create account'
    end

    scenario 'shows username on the homepage after signup' do
      expect(page).to have_content user.email
    end
  end
end

feature 'logging in' do
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    visit new_session_url
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_on 'Login', match: :first
  end

  scenario 'shows username on the homepage after login' do
    expect(page).to have_content user.email
  end

end

feature 'logging out' do
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    visit new_session_url
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_on 'Login', match: :first
  end

  scenario 'begins with a logged out state' do
    expect(page).to have_selector(:link_or_button, 'Logout')
  end

  scenario 'doesn\'t show username on the homepage after logout' do
    click_on 'Logout'

    expect(page).not_to have_content user.email
  end

end