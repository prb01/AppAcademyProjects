require 'spec_helper'

feature 'Software Engineer' do
  scenario 'has Start an application link' do
    visit '/course/software-engineer-online'
    expect(page).to have_content 'Start an application'
  end

  feature 'application' do
    before(:each) { visit '/apply-now' }

    # scenario 'has Submit button' do
    #   click_on 'Accept All Cookies'

    #   expect(page).to have_content 'Submit'
    #   # expect(page).to have_selector(:link_or_button, 'Submit')
    # end

    scenario 'faulty applicaton' do
      click_on 'Accept All Cookies'
      click_on(id: 'input_73')
      # click_on 'input_73'
    end
  end
end