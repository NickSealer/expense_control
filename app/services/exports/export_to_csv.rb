# frozen_string_literal: true

module Exports
  class ExportToCsv < ApplicationService
    require 'csv'

    def initialize(records)
      @records = records
    end

    def execute
      CSV.generate do |csv|
        csv << @records.first.class.column_names

        @records.each do |record|
          csv << record.attributes.values
        end
      end
    end
  end
end
