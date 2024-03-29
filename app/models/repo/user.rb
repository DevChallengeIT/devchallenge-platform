# frozen_string_literal: true

module Repo
  class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, and :omniauthable
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable,
           :omniauthable, omniauth_providers: %i[github google_oauth2]

    extend FriendlyId
    friendly_id :full_name, use: :slugged

    has_many :taxon_entities, as: :entity, dependent: :destroy_async
    has_many :taxons, through: :taxon_entities
    has_many :members, dependent: :destroy_async
    has_many :challenges, through: :members

    validates :full_name, presence: true

    after_create do
      CreateSubscriberJob.perform_later(user: self)
    end
  end
end
