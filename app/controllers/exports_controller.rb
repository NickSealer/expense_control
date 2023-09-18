# frozen_string_literal: true

class ExportsController < ApplicationController
  before_action :authenticate_user!

  def data_to_csv
    return redirect_to export_url, alert: 'Select a valid category.' if params[:export_type].blank?

    records = Exports::FilterRecords.execute(current_user, params) unless params[:from_date].blank?
    @records_to_csv = Exports::ExportToCsv.execute(records) if records.count.positive?
    return redirect_to export_url, alert: 'No data found.' unless @records_to_csv

    respond_to do |format|
      format.csv { send_data @records_to_csv, filename: "#{params[:export_type]}-records-#{Date.today}.csv" }
    end
  end
end
