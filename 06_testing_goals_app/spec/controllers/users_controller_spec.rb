require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    it 'renders the user sign-up page' do
      get :new

      expect(response).to render_template('new')
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    before(:each) { FactoryBot.create(:user) }

    it 'renders the user specific page' do
      get :show, params: { id: 1 }

      expect(response).to render_template('show')
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context 'with valid params' do
      it 'redirects to user specific page' do
        post :create, params: { user: { email: 'unique@test.com', password: 'password' } }

        expect(response).to redirect_to(user_url(User.last))
      end
    end
    
    context 'with invalid params' do
      it 'renders the #new sign-up page' do
        post :create, params: { user: { email: 'unique2@test.com', password: '123' } }

        expect(response).to render_template('new')
        expect(flash[:errors]).not_to be_nil
      end
    end
  end
end
