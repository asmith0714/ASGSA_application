require "test_helper"

class EventMemberJoinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event_member_join = event_member_joins(:one)
  end

  test "should get index" do
    get event_member_joins_url
    assert_response :success
  end

  test "should get new" do
    get new_event_member_join_url
    assert_response :success
  end

  test "should create event_member_join" do
    assert_difference("EventMemberJoin.count") do
      post event_member_joins_url, params: { event_member_join: { attended: @event_member_join.attended, rsvp: @event_member_join.rsvp } }
    end

    assert_redirected_to event_member_join_url(EventMemberJoin.last)
  end

  test "should show event_member_join" do
    get event_member_join_url(@event_member_join)
    assert_response :success
  end

  test "should get edit" do
    get edit_event_member_join_url(@event_member_join)
    assert_response :success
  end

  test "should update event_member_join" do
    patch event_member_join_url(@event_member_join), params: { event_member_join: { attended: @event_member_join.attended, rsvp: @event_member_join.rsvp } }
    assert_redirected_to event_member_join_url(@event_member_join)
  end

  test "should destroy event_member_join" do
    assert_difference("EventMemberJoin.count", -1) do
      delete event_member_join_url(@event_member_join)
    end

    assert_redirected_to event_member_joins_url
  end
end
