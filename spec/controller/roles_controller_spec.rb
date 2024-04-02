# frozen_string_literal: true

# spec/controllers/roles_controller_spec.rb
require 'rails_helper'

RSpec.describe(RolesController, type: :controller) do
  before do
    Rails.application.load_seed

    @member1 = create(:member, :admin)

    # Setup mock OmniAuth user
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456789',
      info: {
        email: @member1.email,
        first_name: @member1.first_name,
        last_name: @member1.last_name,
        image: @member1.avatar_url
      },
      credentials: {
        token: 'token',
        refresh_token: 'refresh token',
        expires_at: DateTime.now
      }
    }
                                                                      )

    # Simulate sign in
    sign_in @member1
  end
  let(:role) { Role.first } # fetch an existing role

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to(be_successful)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: role.id }
      expect(response).to(be_successful)
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to(be_successful)
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: role.id }
      expect(response).to(be_successful)
    end
  end

  describe 'POST #create' do
    it 'does not change the number of Roles' do
      expect do
        post(:create, params: { role: { name: 'Admin' } }) # replace with appropriate attributes
      end.not_to(change(Role, :count))
    end
  end

  context 'with invalid parameters' do
    it 'does not create a new Role' do
      expect do
        post(:create, params: { role: { name: '' } }) # invalid attributes
      end.to(change(Role, :count).by(0))
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      it 'updates the requested role' do
        put :update, params: { id: role.id, role: { name: 'New Name' } }
        role.reload
        expect(role.name).to(eq('New Name'))
      end
    end

    context 'with invalid parameters' do
      it 'does not update the role' do
        put :update, params: { id: role.id, role: { name: '' } }
        role.reload
        expect(role.name).not_to(eq(''))
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'decreases the number of Roles by 1' do
      role_to_delete = Role.create!(name: 'Role to delete', permissions: 'permissions')
      expect do
        delete(:destroy, params: { id: role_to_delete.id })
      end.to(change(Role, :count).by(-1))
    end
  end
end
