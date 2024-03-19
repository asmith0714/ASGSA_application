require 'rails_helper'

RSpec.describe "Admin View", type: :feature do
    before do
        Rails.application.load_seed
    end

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '123456789',
    info: {
        email: "jack@tamu.edu",
        first_name: "Jack",
        last_name: "Doe",
        image: "https://example.com/image.jpg"
    },
    credentials: {
        token: "token",
        refresh_token: "refresh token",
        expires_at: DateTime.now,
    }
    })

    before do
        visit member_google_oauth2_omniauth_callback_path
        click_button "Update Profile"
        visit member_roles_path
        find('#edit_btn').click
        select 'Admin', from: 'member_role_id'
        click_button "Update Member's Role"
    end

    scenario "Nav Links" do
        expect(page).to have_content("Members")
        expect(page).to have_content("Events")
        expect(page).to have_content("Notifications")
        expect(page).to have_content("Role Management")
        expect(page).to have_content("Roles")
    end

    scenario "Admin can change other members' roles" do
        visit member_roles_path
        expect(page).to have_css('#edit_btn')
    end

    scenario "Admin can't create new roles" do
        visit roles_path
        expect(page).to have_no_content("Add New Role")
    end

    scenario "Admin can delete other members" do
        visit members_path
        expect(page).to have_css('#delete_btn')
    end

    scenario "Admin can edit other members" do
        visit members_path
        expect(page).to have_css('#edit_btn')
    end

    scenario "Admin can view other members" do
        visit members_path
        expect(page).to have_css('#show_btn')
    end

    scenario "Admin can create events" do
        visit events_path
        expect(page).to have_content("Add New Event")
    end

    scenario "Admin can delete events" do
        visit events_path
        expect(page).to have_css('#delete_btn')
    end

    scenario "Admin can edit events" do
        visit events_path
        expect(page).to have_css('#edit_btn')
    end

    scenario "Admin can view events" do
        visit events_path
        expect(page).to have_css('#show_btn')
    end

    scenario "Admin can create notifications" do
        visit notifications_path
        expect(page).to have_content("New notification")
    end

    scenario "Admin can delete notifications" do
        visit notifications_path
        expect(page).to have_content("Delete")
    end

    scenario "Admin can edit notifications" do
        visit notifications_path
        expect(page).to have_content("Edit")
    end
end
