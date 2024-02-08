require "application_system_test_case"

class EventMemberJoinsTest < ApplicationSystemTestCase
  setup do
    @event_member_join = event_member_joins(:one)
  end

  test "visiting the index" do
    visit event_member_joins_url
    assert_selector "h1", text: "Event member joins"
  end

  test "should create event member join" do
    visit event_member_joins_url
    click_on "New event member join"

    check "Attended" if @event_member_join.attended
    check "Rsvp" if @event_member_join.rsvp
    click_on "Create Event member join"

    assert_text "Event member join was successfully created"
    click_on "Back"
  end

  test "should update Event member join" do
    visit event_member_join_url(@event_member_join)
    click_on "Edit this event member join", match: :first

    check "Attended" if @event_member_join.attended
    check "Rsvp" if @event_member_join.rsvp
    click_on "Update Event member join"

    assert_text "Event member join was successfully updated"
    click_on "Back"
  end

  test "should destroy Event member join" do
    visit event_member_join_url(@event_member_join)
    click_on "Destroy this event member join", match: :first

    assert_text "Event member join was successfully destroyed"
  end
end
