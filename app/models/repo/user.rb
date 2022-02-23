# frozen_string_literal: true

module Repo
  class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, and :omniauthable
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable

    extend FriendlyId
    friendly_id :full_name, use: :slugged
  end
end
