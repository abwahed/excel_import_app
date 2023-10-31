require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    context 'with an Excel file with valid data' do
      let(:file_path) { Rails.root.join('spec/fixtures/files/valid.xlsx') }

      it 'creates users and updates the view' do
        file = fixture_file_upload(file_path, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

        expect do
          post :create, params: { user: { file: } }, format: :turbo_stream
        end.to change(User, :count).by(2)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Total User Data - 2')
        expect(response.body).to include('Successfully Created Users - 2')
        expect(response.body).to include('Failed To Create Users - 0')
        expect(response.body).to include('Failure Reasons Are: []')
      end
    end

    context 'with an Excel file with invalid data' do
      # Replace with an invalid test file path
      let(:file_path) do
        Rails.root.join('spec/fixtures/files/invalid.xlsx')
      end
      it 'does not create users and renders an error message' do
        file = fixture_file_upload(file_path, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

        expect do
          post :create, params: { user: { file: } }, format: :turbo_stream
        end.not_to change(User, :count)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Total User Data - 2')
        expect(response.body).to include('Successfully Created Users - 0')
        expect(response.body).to include('Failed To Create Users - 2')
        expect(response.body).to include('Failure Reasons Are')
      end
    end

    context 'with an Excel file with valid and invalid data' do
      let(:file_path) { Rails.root.join('spec/fixtures/files/valid-and-invalid.xlsx') }

      it 'creates users and updates the view' do
        file = fixture_file_upload(file_path, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

        expect do
          post :create, params: { user: { file: } }, format: :turbo_stream
        end.to change(User, :count).by(6)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Total User Data - 8')
        expect(response.body).to include('Successfully Created Users - 6')
        expect(response.body).to include('Failed To Create Users - 2')
        expect(response.body).to include('Failure Reasons Are')
      end
    end

    context 'without a file' do
      it 'renders an error message' do
        post :create, params: { user: { file: nil } }, format: :turbo_stream

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Please select an Excel file.')
      end
    end
  end
end
