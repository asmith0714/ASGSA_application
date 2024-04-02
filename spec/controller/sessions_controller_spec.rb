# frozen_string_literal: true

# spec/controllers/sessions_controller_spec.rb
require 'rails_helper'

RSpec.describe(Members::SessionsController, type: :controller) do
  before do
    Rails.application.load_seed
  end

  include Devise::Test::ControllerHelpers

  describe 'GET #new' do
    it 'assigns all events to @events' do
      @request.env['devise.mapping'] = Devise.mappings[:member]
      get :new
      expect(@controller.instance_variable_get('@events')).to(eq(Event.all))
    end
  end

  describe 'DELETE #destroy' do
    let(:member) { create(:member) }

    it 'redirects to the new session path' do
      @request.env['devise.mapping'] = Devise.mappings[:member] # Add this line
      sign_in member
      delete :destroy
      expect(response).to(redirect_to(new_member_session_path))
    end
  end
end
