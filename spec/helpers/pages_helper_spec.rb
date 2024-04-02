# frozen_string_literal: true

# spec/helpers/application_helper_spec.rb
require 'rails_helper'

RSpec.describe(ApplicationHelper, type: :helper) do
  before do
    allow(helper).to(receive(:url_for)) do |options|
      "/?#{options.to_query}"
    end
  end

  describe '#sort_link_to' do
    it 'returns a link with the correct sort parameters' do
      allow(helper).to(receive(:params).and_return({ sort: 'name', direction: 'asc' }))
      expect(helper.sort_link_to('Name', 'name')).to(include('sort=name', 'direction=desc'))
    end

    it 'defaults to ascending order if no sort parameter is present' do
      allow(helper).to(receive(:params).and_return({}))
      expect(helper.sort_link_to('Name', 'name')).to(include('sort=name', 'direction=asc'))
    end
  end

  describe '#sort_arrow' do
    it 'returns an up arrow for ascending order' do
      allow(helper).to(receive(:params).and_return({ sort: 'name', direction: 'asc' }))
      expect(helper.sort_arrow('name')).to(eq('↑'))
    end

    it 'returns a down arrow for descending order' do
      allow(helper).to(receive(:params).and_return({ sort: 'name', direction: 'desc' }))
      expect(helper.sort_arrow('name')).to(eq('↓'))
    end

    it 'defaults to an up arrow if no sort parameter is present' do
      allow(helper).to(receive(:params).and_return({}))
      expect(helper.sort_arrow('first_name')).to(eq('↑'))
    end
  end
end
