require 'rails_helper'
require 'securerandom'

RSpec.describe Micropost, type: :model do
  let(:user) { User.create(name: 'Taro', email: 'taro@example.com') }
  let(:micropost) { Micropost.new(content: 'Post', user_id: user.id) }
  let(:over_140) { SecureRandom.alphanumeric(141) }

  it 'is valid with a content' do
    expect(micropost).to be_valid
  end

  it 'is invalid without a content' do
    micropost.content = nil
    micropost.valid?
    expect(micropost.errors[:content]).to include("can't be blank")
  end

  it 'is invalid content over 140 characters' do
    micropost.content = over_140
    micropost.valid?
    expect(micropost.errors[:content]).to include('is too long (maximum is 140 characters)')
  end

  it 'is invalid without user_id' do
    micropost.user_id = nil
    micropost.valid?
    expect(micropost.errors.full_messages).to include('User must exist')
  end
end
