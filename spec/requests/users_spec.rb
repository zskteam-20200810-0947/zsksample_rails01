require 'rails_helper'

RSpec.describe '/users', type: :request do
  let(:user) { User.create(name: 'abc', email: 'abc@abc.com') }
  let(:user_params) { { name: 'def', email: 'def@abc.com' } }
  let(:un_user_params) { { name: '', email: 'def@abc.com' } }

  describe 'GET /index' do
    it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
      get users_path
      expect(response).to be_successful
    end

    it 'indexアクションにリクエストすると200レスポンスが返ってくる' do
      get users_path
      expect(response.status).to eq 200
    end
  end

  describe 'GET /show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      get user_path(user)
      expect(response).to be_successful
    end

    it 'showアクションにリクエストすると200レスポンスが返ってくる' do
      get user_path(user)
      expect(response.status).to eq 200
    end
  end

  describe 'GET /new' do
    it 'newアクションにリクエストすると正常にレスポンスが返ってくる' do
      get new_user_path
      expect(response).to be_successful
    end

    it 'newアクションにリクエストすると200レスポンスが返ってくる' do
      get new_user_path
      expect(response.status).to eq 200
    end
  end

  describe 'GET /edit' do
    it 'editアクションにリクエストすると正常にレスポンスが返ってくる' do
      get edit_user_path(user)
      expect(response).to be_successful
    end

    it 'editアクションにリクエストすると正常にレスポンスが返ってくる' do
      get edit_user_path(user)
      expect(response.status).to eq 200
    end
  end

  describe 'POST /create' do
    context 'Userモデルへの保存に成功したとき' do
      it 'Userモデルのレコードが１つ増加する' do
        expect do
          post users_path, params: { user: user_params }
        end.to change(User, :count).by(1)
      end

      it 'ユーザー詳細ページ(show)にリダイレクトされる' do
        post users_path, params: { user: user_params }
        expect(response).to redirect_to user_path(User.last)
      end
    end

    context 'Userモデルへの保存に失敗したとき' do
      it 'Userレコードが増加しない' do
        expect do
          post users_path, params: { user: un_user_params }
        end.to change(User, :count).by(0)
      end

      it '新規ユーザー作成ページ(new)にrenderされる' do
        post users_url, params: { user: un_user_params }
        expect(response.body).to include 'New User'
      end
    end
  end

  describe 'PATCH /update' do
    context 'ユーザー情報の更新に成功した時' do
      it 'ユーザー情報が更新される' do
        patch user_url(user), params: { user: user_params }
        user.reload
        expect(user.name).to eq 'def'
      end

      it 'ユーザー詳細ページ(show)にリダイレクトされる' do
        patch user_path(user), params: { user: user_params }
        user.reload
        expect(response).to redirect_to(user_url(user))
      end
    end

    context 'ユーザー情報の更新に失敗した時' do
      it 'ユーザー編集ページ(:edit)にレンダーされる' do
        patch user_url(user), params: { user: un_user_params }
        expect(response.body).to include 'error' && 'Editing User'
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'ユーザー情報を削除するとUserレコードが１減る' do
      user.save
      expect { delete user_path(user) }.to change(User, :count).by(-1)
    end

    it 'ユーザー情報を削除するとユーザー一覧(:index)にリダイレクトされる' do
      delete user_path(user)
      expect(response).to redirect_to(users_path)
    end
  end
end
