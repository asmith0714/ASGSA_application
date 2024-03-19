require 'rails_helper'

RSpec.describe "Member View", type: :feature do
    before do
        Rails.application.load_seed
    end
  
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456789',
        info: {
        email: "john@tamu.edu",
        first_name: "John",
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
        select 'Member', from: 'member_role_id'
        click_button "Update Member's Role"
    end

    scenario "Nav Links" do
        expect(page).to have_content("Members")
        expect(page).to have_content("Events")
        expect(page).to have_no_content("Notifications")
        expect(page).to have_no_content("Role Management")
        expect(page).to have_no_content("Roles")
    end

    scenario "Member can't delete other members" do
        visit members_path
        expect(page).to have_no_css('#delete_btn')
        expect(page).to have_css('#edit_btn', count: 1)
        expect(page).to have_css('#show_btn')
    end

    scenario "Member can edit limited information on their profile" do
        visit members_path
        expect(page).to have_css('#edit_btn', count: 1)
        find('#edit_btn').click
        expect(page).to have_content("Edit Profile")
        select 'MS', from: 'member[degree]'
        fill_in "member[area_of_study]", with: "Computer Science"
        fill_in "member[res_topic]", with: "Topic A"
        fill_in "member[res_lab]", with: "Lab A"
        fill_in "member[res_description]", with: "This is a description for research topic A" 
        fill_in "member[food_allergies]", with: "peanuts, dairy, gluten"
        click_button "Update Profile"
        expect(page).to have_content("Member was successfully updated")
        expect(page).to have_content("MS")
        expect(page).to have_content("Computer Science")
        expect(page).to have_content("Topic A")
        expect(page).to have_content("Lab A")
        expect(page).to have_content("This is a description for research topic A")
        expect(page).to have_content("peanuts, dairy, gluten")
    end

    scenario "Member cannot edit certain fields on their profile" do
        visit members_path
        find('#edit_btn').click
        expect(page).to have_content("Edit Profile")
        expect(page).to have_field('member[first_name]', readonly: true)
        expect(page).to have_field('member[last_name]', readonly: true)
        expect(page).to have_field('member[email]', readonly: true)
        expect(page).to have_field('member[points]', readonly: true)
        expect(page).to have_field('member[position]', readonly: true)
    end

    scenario "Member can't edit other members' info" do
        visit members_path
        expect(page).to have_css('#edit_btn', maximum: 1)
    end

    scenario "Member can view other members" do
        visit members_path
        expect(page).to have_css('#show_btn')
    end

    scenario "Member can't create events" do
        visit events_path
        expect(page).to have_no_css('#create_btn')
    end

    scenario "Member can't delete events" do
        visit events_path
        expect(page).to have_no_css('#delete_btn')
    end

    scenario "Member can't edit events" do
        visit events_path
        expect(page).to have_no_css('#edit_btn')
    end

    scenario "Member can view events" do
        visit events_path
        expect(page).to have_css('#show_btn')
    end
  
end
