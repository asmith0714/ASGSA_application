# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(MemberRolesController, type: :routing) do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/member_roles').to(route_to('member_roles#index'))
    end

    it 'routes to #new' do
      expect(get: '/member_roles/new').to(route_to('member_roles#new'))
    end

    it 'routes to #show' do
      expect(get: '/member_roles/1').to(route_to('member_roles#show', id: '1'))
    end

    it 'routes to #edit' do
      expect(get: '/member_roles/1/edit').to(route_to('member_roles#edit', id: '1'))
    end

    it 'routes to #create' do
      expect(post: '/member_roles').to(route_to('member_roles#create'))
    end

    it 'routes to #update via PUT' do
      expect(put: '/member_roles/1').to(route_to('member_roles#update', id: '1'))
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/member_roles/1').to(route_to('member_roles#update', id: '1'))
    end

    it 'routes to #destroy' do
      expect(delete: '/member_roles/1').to(route_to('member_roles#destroy', id: '1'))
    end
  end
end
