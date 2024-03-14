class Invitee < ApplicationRecord
  validates :full_name, presence: true
  validates :email, presence: true, format: { with: Devise::email_regexp },
    uniqueness: { case_sensitive: false }
end
