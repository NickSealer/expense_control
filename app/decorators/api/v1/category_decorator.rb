# frozen_string_literal: true

module Api
  module V1
    class CategoryDecorator < Draper::Decorator
      delegate_all

      def self.collection_decorator_class
        Api::V1::PaginatingDecorator
      end

      def basic_info
        {
          id: object.id,
          name: object.name.titleize,
          description: object.description,
          author: object.user_id,
          created_at: object.created_at.strftime('%F - %T'),
          updated_at: object.created_at.strftime('%F - %T')
        }
      end

      def collection(categories)
        records = []
        categories.each { |category| records.push(Api::V1::CategoryDecorator.decorate(category).basic_info) }
        records
      end
    end
  end
end
