# frozen_string_literal: true

module Api
  module V1
    class PaginatingDecorator < Draper::CollectionDecorator
      delegate :current_page, :per_page, :offset, :total_entries, :total_pages
    end
  end
end
