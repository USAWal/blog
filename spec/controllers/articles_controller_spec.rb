require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  context 'there are 25 articles' do
    before(:each) { create_list :queued_article, 25 }

    context 'list of articles without params was requested' do
      before(:each) { get :index }

      it 'assigns @articles to first 10 articles ordered descending by created_at' do
        expect(assigns :articles).to eq Article.order(created_at: :desc).first 10
      end

      it 'returns http success' do
        expect(response).to have_http_status :success
      end

      it 'renders index template' do
        expect(response).to render_template :index
      end
    end

    context 'second page of articles was requested' do
      before(:each) { get :index, page: 2 }

      it 'assigns @articles to second 10 articles ordered descending by created_at' do
        expect(assigns :articles).to eq Article.order(created_at: :desc).offset(10).first 10
      end
    end

    context 'article was requested' do
      before(:each) { get :show, id: Article.first.friendly_id }

      it 'assigns @article to found article' do
        expect(assigns :article).to eq Article.first
      end

      it 'assigns @comment to new comment' do
        expect(assigns(:comment).new_record?).to be_truthy
      end

      it 'assigns @comment article to found article' do
        expect(assigns(:comment).article).to eq Article.first
      end

      it 'returns http success' do
        expect(response).to have_http_status :success
      end

      it 'renders show template' do
        expect(response).to render_template :show
      end
    end
  end
end
