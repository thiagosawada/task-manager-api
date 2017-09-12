require 'rails_helper'

RSpec.describe User, type: :model do

  # before { @user = FactoryGirl.build(:user) }

  # # Expectativas
  # it { expect(@user).to respond_to(:email) }
  # it { expect(@user).to respond_to(:name) }
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
  it { is_expected.to validate_uniqueness_of(:auth_token) }

  # Para testas métodos de instância é preciso utilizar '#'
  describe '#info' do
    it 'returns email, created_at and a token' do
      user.save!

      # Mock é um objeto dublê
      # Quando chamar o método friendly_token do Devise, retorne o que eu vou passar 'abc123xyzTOKEN'
      allow(Devise).to receive(:friendly_token).and_return('abc123xyzTOKEN')

      expect(user.info).to eq("#{user.email} - #{user.created_at} - Token: abc123xyzTOKEN")
    end
  end

  # A exclamação significa que o método vai alterar o estado, algum atributo do objeto
  describe '#generate_authentication_token!' do
    it 'generates a unique auth token' do
      allow(Devise).to receive(:friendly_token).and_return('abc123xyzTOKEN')
      user.generate_authentication_token!

      expect(user.auth_token).to eq('abc123xyzTOKEN')

    end

    it 'generates another token when the current auth token has already been taken' do

        # Quando o friendly_token é chamado da primeira vez, ele retorna o abc123... e na segunda ABCxyz...
        allow(Devise).to receive(:friendly_token).and_return('abc123TOKENxyz', 'abc123TOKENxyz', 'ABCxyz123456789')

        # O friendly_token vai gerar na primeira e na segunda vez o mesmo token.

        existing_user = create(:user) # Gerou o token pela primeira vez

        user.generate_authentication_token! # Gerou o mesmo token pela segunda vez e depois gerar um novo

        expect(user.auth_token).not_to eq(existing_user.auth_token)
    end
  end

end
