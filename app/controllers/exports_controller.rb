# frozen_string_literal: true

class ExportsController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_category, :validate_from_date, only: :data_to_csv

  def data_to_csv
    records = Exports::FilterRecords.execute(current_user, params)
    records_to_csv = Exports::ExportToCsv.execute(records) if records.count.positive?
    return redirect_to export_url, alert: 'No data found.' unless records_to_csv

    respond_to do |format|
      format.csv { send_data records_to_csv, filename: "#{params[:export_type]}-records-#{Date.today}.csv" }
    end
  end

  private

  def validate_category
    redirect_to export_url, alert: 'Select a valid category.' if params[:export_type].blank?
  end

  def validate_from_date
    redirect_to export_url, alert: 'Select From Date.' if params[:from_date].blank?
  end
end
