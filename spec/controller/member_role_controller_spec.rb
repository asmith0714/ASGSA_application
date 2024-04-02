require 'rails_helper'

RSpec.describe MemberRolesController, type: :controller do
    before do
        Rails.application.load_seed
    end 
    
    let(:role) { Role.find_by(name: 'Admin') }
    let(:member) { create(:member) }
    let(:admin) { create(:member, :admin) }
    let(:member_role) { MemberRole.create!(member: member, role: role) }

    before do
        sign_in admin
    end

    describe 'GET #index' do
        it 'returns a success response' do
            get :index
            expect(response).to be_successful
        end
    end
    
    describe 'GET #show' do
        it 'returns a success response' do
            get :show, params: { id: member_role.id }
            expect(response).to be_successful
        end
    end

    describe 'GET #new' do
    it 'returns a success response' do
        get :new
        expect(response).to be_successful
    end
    end

    describe 'GET #edit' do
    it 'returns a success response' do
        get :edit, params: { id: member_role.id }
        expect(response).to be_successful
    end
    end
    
    describe 'POST #create' do
        context 'with valid parameters' do
            it 'creates a new MemberRole' do
            expect {
                post :create, params: { member_role: { member_id: member.id, role_id: role.id } }
            }.to change(MemberRole, :count).by(2)
        end
    end

    context 'with invalid parameters' do
        it 'does not create a new MemberRole' do
            expect {
            post :create, params: { member_role: { member_id: nil, role_id: nil } }
            }.to change(MemberRole, :count).by(0)
        end
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) { { role_id: role.id } }

      it 'updates the requested member_role' do
        put :update, params: { id: member_role.id, member_role: new_attributes }
        member_role.reload
        expect(member_role.role_id).to eq(new_attributes[:role_id])
      end
    end
  end

  let(:valid_attributes) { { member_id: member.id, role_id: role.id } }

  describe 'DELETE #destroy' do
    it 'destroys the requested member_role' do
        member_role = MemberRole.create! valid_attributes
        expect {
        delete :destroy, params: { id: member_role.id }
        }.to change(MemberRole, :count).by(-1)
    end
  end
end