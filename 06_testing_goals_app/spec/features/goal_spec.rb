require 'spec_helper'
require 'rails_helper'

feature "goals" do
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    visit new_session_url
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_on 'Login'
  end

  feature 'the goal add process' do
    scenario 'has a new goal page' do
      visit new_goal_url

      expect(page).to have_content 'Add new goal'
    end

    feature 'adding a new goal' do
      let(:goal) { FactoryBot.build(:goal) }
      before(:each) { visit new_goal_url }
        
      scenario 'add goal with incorrect parameters' do
        click_on 'Add goal'

        expect(page).to have_content 'Error'
      end

      scenario 'add goal with correct parameters: public & in progress' do
        fill_in 'title', with: goal.title
        fill_in 'details', with: goal.details
        click_on 'Add goal'
        
        expect(page).to have_content goal.title
        expect(page).to have_content goal.details
        expect(page).to have_content 'Public'
        expect(page).to have_content 'In Progress'
      end

      scenario 'add goal with correct parameters: public & in progress' do
        fill_in 'title', with: goal.title
        fill_in 'details', with: goal.details
        check 'Private'
        check 'Completed'
        
        click_on 'Add goal'
        
        expect(page).to have_content goal.title
        expect(page).to have_content goal.details
        expect(page).to have_content 'Private'
        expect(page).to have_content 'Completed'
      end
    end
  end

  let(:new_goal) { FactoryBot.create(:goal, user_id: User.first.id) }
  before(:each) { visit goal_url(new_goal) }

  feature 'updating a goal' do
    scenario 'move goal to completed' do
      click_on 'Completed'

      expect(page).to have_content 'Completed'
    end

    scenario 'move goal to in progress' do
      click_on 'Completed'
      click_on 'In Progress'

      expect(page).to have_content 'In Progress'
    end
  end

  feature 'deleting a goal' do
    scenario 'before deleting goal' do
      expect(page).to have_selector(:link_or_button, 'Destroy')
    end

    scenario 'goes back to user profile after deleting goal' do
      click_on 'Destroy Goal'

      expect(page).to have_content 'Profile'
    end
  end
end