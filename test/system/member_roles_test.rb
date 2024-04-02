# frozen_string_literal: true

require 'application_system_test_case'

class MemberRolesTest < ApplicationSystemTestCase
  setup do
    @member_role = member_roles(:one)
  end

  test 'visiting the index' do
    visit member_roles_url
    assert_selector 'h1', text: 'Member roles'
  end

  test 'should create member role' do
    visit member_roles_url
    click_on 'New member role'

    fill_in 'Id', with: @member_role.id
    fill_in 'Member', with: @member_role.member_id
    fill_in 'Role', with: @member_role.role_id
    click_on 'Create Member role'

    assert_text 'Member role was successfully created'
    click_on 'Back'
  end

  test 'should update Member role' do
    visit member_role_url(@member_role)
    click_on 'Edit this member role', match: :first

    fill_in 'Id', with: @member_role.id
    fill_in 'Member', with: @member_role.member_id
    fill_in 'Role', with: @member_role.role_id
    click_on 'Update Member role'

    assert_text 'Member role was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Member role' do
    visit member_role_url(@member_role)
    click_on 'Destroy this member role', match: :first

    assert_text 'Member role was successfully destroyed'
  end
end
