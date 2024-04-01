# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def sort_link_to(name, column, **options)
    direction = if params[:sort] == column.to_s
                  params[:direction] == 'asc' ? 'desc' : 'asc'
                else
                  'asc'
                end

    link_to(name, request.params.merge(sort: column, direction: direction), **options)
  end

  def sort_arrow(column)
    direction = params[:direction] || 'asc'
    if column == params[:sort] || (column == 'first_name' && params[:sort].nil?) || (column == 'points' && params[:sort].nil?)
      direction == 'asc' ? '↑' : '↓'
    end
  end
end
