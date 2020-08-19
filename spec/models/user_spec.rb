require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(name: 'Taro', email: 'taro@example.com') }

  it 'is valid with a name, user_id, email' do
    expect(user).to be_valid
  end

  it 'is invalid without a name' do
    user.name = nil
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without an email address' do
    user.email = nil
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end
end
