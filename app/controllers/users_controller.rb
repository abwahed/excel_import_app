# frozen_string_literal: true

class UsersController < ApplicationController
  def new
  end

  def create
    excel_file = import_file_params[:file]

    if excel_file.present?
      total_users = 0
      successful_users = 0
      failed_users = 0
      failure_reasons = []

      spreadsheet = Roo::Excelx.new(excel_file.path)

      spreadsheet.sheets.each do |sheet_name|
        spreadsheet.default_sheet = sheet_name

        (2..spreadsheet.last_row).each do |row_index|
          first_name = spreadsheet.cell(row_index, 1)
          last_name = spreadsheet.cell(row_index, 2)
          email = spreadsheet.cell(row_index, 3)

          total_users += 1

          user = User.new(first_name:, last_name:, email:)

          if user.save
            successful_users += 1
          else
            failed_users += 1
            failure_reasons << "Sheet '#{sheet_name}' - Row #{row_index}: #{user.errors.full_messages.join(', ')}"
          end
        end
      end

      render turbo_stream: [
        turbo_stream.update('total-data', "Total User Data - #{total_users}".html_safe),
        turbo_stream.update('success-data', "Successfully Created Users - #{successful_users}".html_safe),
        turbo_stream.update('failure-data', "Failed To Create Users - #{failed_users}".html_safe),
        turbo_stream.update('failure-reasons', "Failure Reasons Are: #{failure_reasons}")
      ]
    else
      render turbo_stream: [
        turbo_stream.update('failure-reasons', 'Please select an Excel file.')
      ]
    end
  end

  private

  def import_file_params
    params.require(:user).permit(:file)
  end
end
