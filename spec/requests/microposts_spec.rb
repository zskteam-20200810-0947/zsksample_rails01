require 'rails_helper'
RSpec.describe '/microposts', type: :request do
  let(:user) { User.create(name: 'Taro', email: 'taro@example.com') }
  let(:micropost) { Micropost.create(content: 'sample', user_id: user.id) }
  let(:un_micropost_params) { { content: ' ', user_id: user.id } }
  let(:micropost_params) { { content: 'sample2', user_id: user.id } }

  describe 'GET /index' do
    context 'indexアクションへリクエストしたとき' do
      it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
        get microposts_url
        expect(response).to be_successful
      end

      it 'indexアクションにリクエストすると200レスポンスが返ってくる' do
        get microposts_url
        expect(response.status).to eq 200
      end
    end

    context 'pagination' do
      before do
        user
        5.times { Micropost.create(content: 'sample', user_id: user.id) }
        Micropost.create(content: 'pagination_test', user_id: user.id)
      end

      it '1ページ目には最後に生成したMicropostがない' do
        get microposts_path, params: { page: 1 }
        expect(response.body).not_to include "pagination_test"
      end

      it '2ページ目には最後に生成したMicropostがある' do
        get microposts_path, params: { page: 2 }
        expect(response.body).to include "pagination_test"
      end
    end
  end

  describe 'GET /show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      get micropost_url(micropost)
      expect(response).to be_successful
    end

    it 'showアクションにリクエストすると200レスポンスが返ってくる' do
      get micropost_url(micropost)
      expect(response.status).to eq 200
    end
  end

  describe 'GET /new' do
    it 'newアクションにリクエストすると正常にレスポンスが返ってくる' do
      get new_micropost_url
      expect(response).to be_successful
    end

    it 'newアクションにリクエストすると200レスポンスが返ってくる' do
      get new_micropost_url
      expect(response.status).to eq 200
    end
  end

  describe 'GET /edit' do
    it 'editアクションにリクエストすると正常にレスポンスが返ってくる' do
      get edit_micropost_url(micropost)
      expect(response).to be_successful
    end

    it 'editアクションにリクエストすると正常にレスポンスが返ってくる' do
      get edit_micropost_url(micropost)
      expect(response.status).to eq 200
    end
  end

  describe 'POST /create' do
    context 'Micropostモデルへの保存に成功したとき' do
      it 'Micropostモデルのレコードが１つ増加する' do
        expect do
          post microposts_url, params: { micropost: micropost_params }
        end.to change(Micropost, :count).by(1)
      end

      it 'showにリダイレクトされる' do
        post microposts_url, params: { micropost: micropost_params }
        expect(response).to redirect_to(micropost_url(Micropost.last))
      end
    end

    context 'Micropostモデルへの保存に失敗したとき' do
      it 'Micropostレコードが増加しない' do
        expect do
          post microposts_url, params: { micropost: un_micropost_params }
        end.to change(Micropost, :count).by(0)
      end

      it 'newにrenderされる' do
        post microposts_url, params: { micropost: un_micropost_params }
        expect(response.body).to include 'New Micropost'
      end
    end
  end

  describe 'PATCH /update' do
    context '投稿情報の更新に成功した時' do
      it '投稿が更新される' do
        patch micropost_url(micropost), params: { micropost: micropost_params }
        micropost.reload
        expect(micropost.content).to eq 'sample2'
      end

      it 'showにリダイレクトされる' do
        patch micropost_url(micropost), params: { micropost: micropost_params }
        expect(response).to redirect_to(micropost_url(micropost))
      end
    end

    context '投稿情報の更新に失敗したとき' do
      it '投稿編集ページ(:edit)にレンダーされる' do
        patch micropost_url(micropost), params: { micropost: un_micropost_params }
        expect(response.body).to include 'Editing Micropost'
      end
    end
  end

  describe 'DELETE /destroy' do
    it '投稿情報を削除するとUserレコードが１減る' do
      micropost.save
      expect { delete micropost_path(micropost) }.to change(Micropost, :count).by(-1)
    end

    it '投稿情報を削除するとユーザー一覧(:index)にリダイレクトされる' do
      delete micropost_url(micropost)
      expect(response).to redirect_to(microposts_url)
    end
  end
end
