class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # attr_accessor :name

  # validates_presence_of :name
  validates_uniqueness_of :auth_token

  # Chama o método toda vez que um novo usuário é criado
  before_create :generate_authentication_token!

  def info
    "#{email} - #{created_at} - Token: #{Devise.friendly_token}"
  end

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token

    # Verificar se existe algum usuário no sistema com o mesmo auth_token
    end while User.exists?(auth_token: self.auth_token)
  end

end
