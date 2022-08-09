require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:author) { create (:user) }
  let(:user) { create (:user) }
  let(:question) { create(:question, user: user) }
  let(:second_question) { create :question, user: user }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    before { login author }

    context 'with valid attributes' do
      it 'saves a new answer in the DB' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }
          .to change(question.answers, :count).by(1)
      end

      it 'the author of the answer is an authenticated user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js

        expect(assigns(:answer).user).to eq author
      end

      it 'redirects to show' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }
          .to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login author }

    context 'Author can deletes his answer' do
      let!(:answer) { create :answer, question: question, user: author }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not the author deletes answer' do
      let!(:answer) { create :answer, question: question, user: user }

      it 'try delete the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders questions/show' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'PATCH #update' do
    before { login author }
    
    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'New body' } }, format: :js
        answer.reload

        expect(answer.body).to eq 'New body'
      end

      it 'renders update views' do
        patch :update, params: { id: answer, answer: { body: 'New body' } }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

          answer.reload
        end.to_not change(answer, :body)
      end

      it 'renders update views' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #best' do
    before { login author }

    let!(:second_answer) { create :answer, question: second_question, user: user }

    context 'Author of question' do
      it 'changes the best answer' do
        patch :best, params: { id: answer }, format: :js
        answer.reload

        expect(answer.best).to be true
      end

      it 'renders best view' do
        patch :best, params: { id: answer }, format: :js

        expect(response).to render_template :best
      end
    end

    context 'Not an author of question' do
      it 'tries to change best answer' do
        patch :best, params: { id: second_answer }, format: :js
        second_answer.reload

        expect(second_answer.best).to be false
      end

      it 'renders best view' do
        patch :best, params: { id: second_answer }, format: :js

        expect(response).to render_template :best
      end
    end
  end
end