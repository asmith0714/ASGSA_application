# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(MemberNotificationsController, type: :routing) do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/member_notifications').to(route_to('member_notifications#index'))
    end

    it 'routes to #new' do
      expect(get: '/member_notifications/new').to(route_to('member_notifications#new'))
    end

    it 'routes to #show' do
      expect(get: '/member_notifications/1').to(route_to('member_notifications#show', id: '1'))
    end

    it 'routes to #edit' do
      expect(get: '/member_notifications/1/edit').to(route_to('member_notifications#edit', id: '1'))
    end

    it 'routes to #create' do
      expect(post: '/member_notifications').to(route_to('member_notifications#create'))
    end

    it 'routes to #update via PUT' do
      expect(put: '/member_notifications/1').to(route_to('member_notifications#update', id: '1'))
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/member_notifications/1').to(route_to('member_notifications#update', id: '1'))
    end

    it 'routes to #destroy' do
      expect(delete: '/member_notifications/1').to(route_to('member_notifications#destroy', id: '1'))
    end
  end
end
