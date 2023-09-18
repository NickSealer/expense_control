# frozen_string_literal: true

require 'rails_helper'

shared_examples 'unauthorized user' do
  it 'redirects to sign in page' do
    get url
    expect(response).to have_http_status(:found)
    expect(response).to redirect_to(:user_session)
  end
end

RSpec.describe CategoriesController, type: :request do
  let!(:user) { FactoryBot.create(:user) }
  # let!(:category) { FactoryBot.create(:category, user: user) }

  describe '.index' do
    context 'with logged user' do
      it 'renders the view' do
        sign_in user
        get categories_url
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
      end
    end

    context 'unauthorized user' do
      let(:url) { categories_url }

      it_behaves_like 'unauthorized user'
    end
  end

  # describe '.show' do
  #   context 'unauthorized user' do
  #     let(:url) { categories_url(category) }

  #     # it_behaves_like 'unauthorized user'
  #   end
  # end
end
