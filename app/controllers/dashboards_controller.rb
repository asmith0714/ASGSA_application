# frozen_string_literal: true

class DashboardsController < ApplicationController
  def show
    @events = Event.all
  end
end
