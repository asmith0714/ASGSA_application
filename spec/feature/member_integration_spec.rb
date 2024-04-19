# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('MemberFeatures', type: :feature) do
  before do
    Rails.application.load_seed

    @member1 = create(:member, :admin)
    @member2 = create(:member, :admin)

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

  it 'List all members' do
    visit members_path

    expect(page).to(have_content(@member1.first_name))
    expect(page).to(have_content(@member1.last_name))
  end

  it "View a member's details" do
    visit member_path(@member1)

    expect(page).to(have_content(@member1.first_name))
    expect(page).to(have_content(@member1.last_name))
    expect(page).to(have_content(@member1.email))
  end

  it "Update a member's information" do
    visit edit_member_path(@member1)

    select 'Animal Nutrition', from: 'Area of Study'
    click_button 'Update Profile'

    expect(page).to(have_content('Profile was successfully created'))
    visit member_path(@member1)
    expect(page).to(have_content('Animal Nutrition'))
  end

  it 'Delete a member' do
    visit member_path(@member1)
    expect(page).to(have_content(@member1.first_name))

    click_button 'Delete Member'

    expect(page).to(have_content("You need to sign in or sign up before continuing"))
  end
end
