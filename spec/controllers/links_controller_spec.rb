require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:author) { create :user }
  let(:user) { create :user }
  let!(:question) { create :question, user: author }
  let!(:link) { create :link, linkable: question }

  describe 'DELETE #destroy' do
    context 'Authenticated Author' do
      before { login author }

      it 'delete the link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
      end

      it 'render template destroy' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'Authenticated User' do
      before { login user }

      it 'trying to delete link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
      end

      it 're-render template destroy' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'Guest' do
      it 'trying to delete link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
      end

      it 'not render template destroy' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to_not render_template :destroy
      end
    end
  end
end
