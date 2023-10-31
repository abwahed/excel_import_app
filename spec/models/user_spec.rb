# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'is not valid without a first name' do
    user = build(:user, first_name: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid without a last name' do
    user = build(:user, last_name: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid without an email' do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid without a valid email' do
    user = build(:user, email: 'invalid_email')
    expect(user).not_to be_valid
  end

  it 'is not valid with a duplicate email' do
    user = create(:user)
    user2 = build(:user, email: user.email)
    expect(user2).not_to be_valid
  end
end
