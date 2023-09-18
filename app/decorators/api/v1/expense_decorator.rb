# frozen_string_literal: true

module Api
  module V1
    class ExpenseDecorator < Draper::Decorator
      include Draper::LazyHelpers
      delegate_all

      def self.collection_decorator_class
        Api::V1::PaginatingDecorator
      end

      def basic_info
        {
          id: object.id,
          detail: object.detail,
          value: object.value,
          formatted_value: number_to_currency(object.value),
          date: object.date,
          created_at: object.created_at.strftime('%F - %T'),
          updated_at: object.updated_at.strftime('%F - %T'),
          category: Api::V1::CategoryDecorator.decorate(object.category).basic_info
        }
      end

      def collection(expenses)
        records = []
        expenses.each { |expense| records.push(Api::V1::ExpenseDecorator.decorate(expense).basic_info) }
        records
      end
    end
  end
end
