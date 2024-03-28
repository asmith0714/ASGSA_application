require 'rails_helper'

RSpec.describe "Officer View", type: :feature do
    before do
        Rails.application.load_seed
    
        @member1 = create(:member, :officer)

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
            token: "token",
            refresh_token: "refresh token",
            expires_at: DateTime.now,
          }
        })
    
        # Route to trigger the OmniAuth callback directly for testing
        visit member_google_oauth2_omniauth_callback_path
    
    end

    scenario "Nav Links" do
        expect(page).to have_content("Members")
        expect(page).to have_content("Events")
        expect(page).to have_content("Notifications")
        expect(page).to have_no_content("Role Management")
        expect(page).to have_no_content("Roles")
    end

    scenario "Officer can delete other members" do
        visit members_path
        expect(page).to have_css('#delete_btn')
    end

    scenario "Officer can edit other members" do
        visit members_path
        expect(page).to have_css('#edit_btn')
    end

    scenario "Officer can view other members" do
        visit members_path
        expect(page).to have_css('#show_btn')
    end

    scenario "Officer can create events" do
        visit events_path
        expect(page).to have_content("Create New Event")
    end

    scenario "Officer can edit events" do     
        visit events_path
        expect(page).to have_css('#edit_btn')
    end

    scenario "Officer can delete events" do
        visit events_path
        expect(page).to have_css('#delete_btn')
    end

    scenario "Officer can view events" do
        visit events_path
        expect(page).to have_css('#show_btn')
    end

    scenario "Officer can create notifications" do
        visit new_notification_path
        expect(page).to have_content("New notification")
    end

    scenario "Officer can delete notifications" do
        visit notifications_path
        expect(page).to have_content("Delete")
    end

    scenario "Officer can edit notifications" do
        visit notifications_path
        expect(page).to have_content("Edit")
    end

end