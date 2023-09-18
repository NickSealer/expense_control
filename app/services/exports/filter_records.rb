# frozen_string_literal: true

module Exports
  class FilterRecords < ApplicationService
    def initialize(current_user, params)
      @current_user = current_user
      @params = params
    end

    def execute
      from_date = @params[:from_date].to_datetime.beginning_of_day
      to_date = @params[:to_date].blank? ? Date.today.to_datetime.end_of_day : @params[:to_date].to_datetime.end_of_day

      @records = case @params[:export_type]
                 when 'category'
                   @current_user.categories.where(created_at: from_date..to_date)
                 when 'expense'
                   @current_user.expenses.where(created_at: from_date..to_date)
                 else
                   []
                 end
    end
  end
end
