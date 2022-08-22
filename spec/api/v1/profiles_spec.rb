require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { {
    "CONTENT_TYPE" => "application/json",
    "ACCEPT" => "application/json"
  } }

  describe 'GET /api/v1/profiles/me' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:me) { create :user }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Status OK'

      it_behaves_like 'Public fields returnable' do
        let(:fields) { %w[id email admin created_at updated_at] }
        let(:resource_response) { json['user'] }
        let(:resource) { me }
      end

      it_behaves_like 'Private fields not returnable' do
        let(:fields) { %w[password encrypted_password] }
        let(:resource_response) { json }
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:me) { users.first }
      let(:user) { users.last }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:users) { create_list :user, 3 }
      let(:users_response) { json['users'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Status OK'

      it_behaves_like 'Public fields returnable' do
        let(:fields) { %w[id email admin created_at updated_at] }
        let(:resource_response) { users_response.last }
        let(:resource) { user }
      end

      it_behaves_like 'Private fields not returnable' do
        let(:fields) { %w[password encrypted_password] }
        let(:resource_response) { users_response.last }
      end

      it 'returns all users without me' do
        expect(users_response.size).to eq 2

        users_response.each do |user|
          expect(user).to_not eq me.as_json
        end        
      end
    end
  end
end