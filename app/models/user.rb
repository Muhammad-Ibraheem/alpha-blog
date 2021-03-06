# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :role

  rolify
  has_many :articles, dependent: :destroy
  before_save { self.email = email.downcase }
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }
  VALID_EMAIL_RWEGIX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 105 }, uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_RWEGIX }
  has_secure_password

  def admin?
    has_role?(:admin)
  end

  def self.find_and_authenticate(email, password)
    user = User.find_by(email: email.downcase)
    user if user&.authenticate(password)
  end

  def recent_articles
    articles.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end

  def articles_with_long_title
    articles.where('length(title) > 14')
  end
end
