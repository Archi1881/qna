require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create :access_token }
      let(:user) { create :user }
      let!(:questions) { create_list :question, 2, user: user }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list :answer, 3, user: user, question: question }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Status OK'

      it_behaves_like 'Public fields returnable' do
        let(:fields) { %w[id title body created_at updated_at] }
        let(:resource_response) { question_response }
        let(:resource) { question }
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(4)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it_behaves_like 'Public fields returnable' do
          let(:fields) {  %w[id body user_id created_at updated_at] }
          let(:resource_response) { answer_response }
          let(:resource) { answer }
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:method) { :post }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create :access_token }
      let(:question) { { title: 'Test Title', body: 'Test Body' } }
      let(:question_response) { json['question'] }

      let(:question_request) {
        post api_path, params: { 
          access_token: access_token.token,
          question: question
        }, headers: headers 
      }

      it_behaves_like 'Status OK' do
        let(:request) { question_request }
      end

      it_behaves_like 'Public fields returnable' do
        let(:request) { question_request }
        let(:fields) {  %w[id title body created_at updated_at user] }
        let(:resource_response) { question_response }
        let(:resource) { Question.first }
      end

      it 'saves question in database' do
        expect { question_request }.to change(Question, :count).by(1)
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:method) { :patch }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:user) { create :user }
    let!(:question) { create :question, user: user }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) {
        create :access_token,
        resource_owner_id: user.id
      }

      let(:new_params_for_question) { { title: 'New Title', body: 'New Body' } }
      let(:question_response) { json['question'] }

      let(:question_request) {
        patch api_path, params: { 
          access_token: access_token.token,
          question: new_params_for_question
        }, headers: headers 
      }

      it_behaves_like 'Status OK' do
        let(:request) { question_request }
      end

      it_behaves_like 'Public fields returnable' do
        let(:request) { question_request }
        let(:fields) {  %w[id title body created_at updated_at user] }
        let(:resource_response) { question_response }
        let(:resource) { Question.first }
      end

      it 'saves question in database with new params' do
        question_request
        expect(Question.last.body).to eq 'New Body'
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:method) { :delete }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:user) { create :user }
    let!(:question) { create :question, user: user }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) {
        create :access_token,
        resource_owner_id: user.id
      }

      let(:question_response) { json['question'] }

      let(:question_request) {
        delete api_path,
        params: { 
          access_token: access_token.token,
          question_id: question.id
        }, headers: headers 
      }

      it_behaves_like 'Status OK' do
        let(:request) { question_request }
      end

      it 'deletes the question from database' do
        expect { question_request }.to change(Question, :count).by(-1)
      end
    end
  end
end