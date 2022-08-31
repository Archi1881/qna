require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:question) { create :question, title: 'Title for the Question', body: 'Some Body'  }

  describe 'GET #index' do
    before { allow(SearchService).to receive(:call).and_return(question) }

    context 'with valid attributes' do
      before { get :index, params: { query: 'For', resource: 'All' } }

      it 'Status OK' do
        expect(response).to be_successful
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end

      it 'question assign to results' do
        expect(assigns(:results)).to eq question
      end
    end

    context 'with invalid params[:resource]' do
      before { get :index, params: { query: 'test', resource: 'WrongResource' } }

      it 'Status 3xx' do
        expect(response.status).to eq 302
      end 

      it 'redirect to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end
end