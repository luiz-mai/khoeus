require 'tokens'

class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest

  has_secure_password

  has_many :classrooms, through: :subscriptions
  has_many :subscriptions

  has_attached_file :photo

  validates :name,
            presence: true
  validates :email,
            presence: true,
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
            uniqueness: {case_sensitive: false}
  validates :password,
            presence: true,
            confirmation: true,
            length: {minimum: 8}
  validates :password_confirmation,
            presence: true
  validates :cep,
            presence: true,
            length: {is: 8},
            numericality: {only_integer: true}
  validates :address,
            presence: true
  validates :number,
            presence: true,
            numericality: {only_integer: true}
  validates :neighborhood,
            presence: true
  validates :city,
            presence: true
  validates :state,
            presence: true,
            length: {is: 2}
  validates :country,
            presence: true


  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/


  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  private
  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token  = Tokens.new_token
    self.activation_digest = Tokens.digest(activation_token)
  end
end
