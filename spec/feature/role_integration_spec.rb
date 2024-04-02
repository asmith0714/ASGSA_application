# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Creating a Role', type: :feature) do
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

    # Route to trigger the OmniAuth callback directly for testing
    visit member_google_oauth2_omniauth_callback_path
  end

  it 'valid inputs' do
    visit new_role_path
    fill_in 'role[name]', with: 'Admin-Test'
    fill_in 'role[permissions]', with: 'all'
    click_on 'Create Role'
    visit roles_path
    expect(page).to(have_content('1'))
    expect(page).to(have_content('Admin-Test'))
    expect(page).to(have_content('all'))
  end

  it 'checking database' do
    visit new_role_path
    fill_in 'role[name]', with: 'Admin-Test'
    fill_in 'role[permissions]', with: 'all'
    click_on 'Create Role'
    expect(Role.last.name).to(eq('Admin-Test'))
    expect(Role.last.permissions).to(eq('all'))
  end

  it 'valid inputs' do
    visit new_role_path
    click_on 'Create Role'
    expect(page).to(have_content("Name can't be blank"))
    expect(page).to(have_content("Permissions can't be blank"))
  end
end
