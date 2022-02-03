require 'spec_helper'
require 'rails_helper'

feature 'a user profile' do
  let(:user) { User.create(email: 'test@test.com', password: 'password') } 
  before(:each) do
    visit new_session_url
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_on 'Login'

    visit user_url(user)
  end

  scenario 'has an \'add comment\' button' do
    expect(page).to have_selector(:link_or_button, 'Add Comment')
  end

  feature 'adding a comment' do
    scenario 'with invalid params shows error' do
      click_on 'Add Comment'

      expect(page).to have_content 'Error'
    end

    scenario 'with valid params adds comment to user profile page' do
      comment = Faker::Lorem.sentences.join(" ")
      fill_in 'body', with: comment
      click_on 'Add Comment'

      expect(page).to have_content comment
    end
  end
end

feature 'a goal' do
  let(:user) { User.create(email: 'test@test.com', password: 'password') }
  let(:goal) { Goal.create(user_id: user.id, title: Faker::Lorem.sentence) } 
  before(:each) do
    visit new_session_url
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_on 'Login'

    visit goal_url(goal)
  end
  
  scenario 'has an \'add comment\' button' do
    expect(page).to have_selector(:link_or_button, 'Add Comment')
  end

  feature 'adding a comment' do
    scenario 'with invalid params shows error' do
      click_on 'Add Comment'

      expect(page).to have_content 'Error'
    end

    scenario 'with valid params adds comment to goal page' do
      comment = Faker::Lorem.sentences.join(" ")
      fill_in 'body', with: comment
      click_on 'Add Comment'

      expect(page).to have_content comment
    end
  end
end