RSpec.shared_examples 'voted' do
  let(:author) { create :user }
  let(:user) { create :user }
  let!(:model) { create(described_class.controller_name.classify.downcase.to_sym, user: author) }

  describe 'POST #positive' do
    before { login user }

    context 'Authenticated Not author' do
      it 'try to add new positive vote' do
        expect { post :positive, params: { id: model }, format: :json }.to change(Vote, :count).by(1)
      end
    end

    context 'Authenticated author' do
      before { login author }

      it 'can not add new positive vote' do
        expect { post :positive, params: { id: model } }.to_not change(Vote, :count)
      end
    end
  end

  describe 'POST #negative' do
    before { login user }

    context 'Authenticated Not author' do
      it 'try to add new negative vote' do
        expect { post :negative, params: { id: model }, format: :json }.to change(Vote, :count).by(1)
      end
    end

    context 'Authenticated author' do
      before { login author }

      it 'can not add new negative vote' do
        expect { post :negative, params: { id: model } }.to_not change(Vote, :count)
      end
    end
  end

  describe 'DELETE #revote' do
    before { login user }

    context 'Authenticated user' do
      it 'revote his vote' do
        post :positive, params: { id: model }
        expect { delete :revote, params: { id: model } }.to change(Vote, :count).by(-1)
      end
    end
  end
end
