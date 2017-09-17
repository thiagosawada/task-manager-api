require 'rails_helper'

RSpec.describe User, type: :model do

  # before { @user = FactoryGirl.build(:user) }

  # # Expectativas
  # it { expect(@user).to respond_to(:email) }
  # it { expect(@user).to respond_to(:password) }
  # it { expect(@user).to respond_to(:password_confirmation) }
  # it { expect(@user).to be_valid }

  ###################

  # subject = User.new

  # build(:user) = FactoryGirl.build(:user) -> Config em rails_helper.rb
  # subject { build(:user) }

  # it { expect(subject).to respond_to(:email) }
  # # É o mesmo que:
  # # it { is_expected.to respond_to(:email) }
  # it { expect(subject).to be_valid }

  ###################

  # Se for let!, o comando é executado antes de ser chamado em outro método

  let(:user) { build(:user) }
  it { expect(user).to respond_to(:email) }

  # context 'when name is blank' do
  #   # before(:each) -> executar o bloco antes de cada teste. Este é o valor default
  #   # before(:all) -> executar o bloco antes de todos os outros testes
  #   before { user.name = '' }

  #   it { expect(user).not_to be_valid }
  # end

  # context 'when name is nil' do
  #   before { user.name = nil }

  #   it { expect(user).not_to be_valid }
  # end

  # => # Com a gem shoulda_matchers

  # it { is_expected.to validate_presence_of(:name) }
  # # É o mesmo que:
  # # it { expect(user).to validate_presence_of(:name) }
  # it { is_expected.to validate_numericality_of(:age) }
  it { is_expected.to validate_presence_of(:email) }
  # Validar se o email é único e case insensitive
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  # Validar confirmação da senha
  it { is_expected.to validate_confirmation_of(:password) }
  # Validar formato de email
  it { is_expected.to allow_value('email@email.com').for(:email) }


end
