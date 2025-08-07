# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
  let(:api_key) { create(:api_key) }
  let(:user) { api_key.bearer }

  before do
    request.headers['Authorization'] = "Bearer #{user.api_keys.first.token}"
  end

  describe 'POST #assign' do
    subject(:assign) do
      post :assign,
           params: { new_owner_id: new_owner_id, serial_number: '123456' }
    end

    let!(:device) { create(:device, serial_number: '123456') }

    context 'when the user is authenticated' do
      context 'when user assigns a device to another user' do
        let(:new_owner_id) { create(:user).id }

        it 'returns an unauthorized response' do
          assign
          expect(response.code).to eq("422")
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Unauthorized' })
        end
      end

      context 'when user assigns a device to self' do
        let(:new_owner_id) { user.id }

        it 'returns a success response' do
          assign
          expect(response).to be_successful
        end
      end
    end

    context 'when the user is not authenticated' do
      before do
        request.headers['Authorization'] = nil
      end

      it 'returns an unauthorized response' do
        post :assign
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #unassign' do
    # TODO: implement the tests for the unassign action
  end
end
