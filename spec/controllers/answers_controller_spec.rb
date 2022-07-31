require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:author) { create :user }
  let(:user) { create :user }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    before { login author }

    context 'with valid attributes' do
      it 'saves a new answer in the DB' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }
          .to change(question.answers, :count).by(1)
      end

      it 'the author of the answer is an authenticated user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        expect(assigns(:answer).user).to eq author
      end

      it 'redirects to show' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }
          .to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login author }

    context 'Author can deletes his answer' do
      let!(:answer) { create :answer, question: question, user: author }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Not the author deletes answer' do
      let!(:answer) { create :answer, question: question, user: user }

      it 'try delete the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to_not change(Answer, :count)
      end

      it 're-renders questions/show' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end
end