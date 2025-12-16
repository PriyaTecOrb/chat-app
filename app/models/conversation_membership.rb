class ConversationMembership < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates :conversation, presence: true
  validates :user, presence: true

  validates :user_id, uniqueness: { scope: :conversation_id }

  scope :admins, -> { where(is_admin: true) }
  scope :with_notifications, -> { where(notifications_enabled: true) }

  after_create_commit :broadcast_membership_change
  after_destroy_commit :broadcast_membership_change

  def unread?
    unread_count > 0
  end

  private

  def broadcast_membership_change
    broadcast_replace_to(
      "user_#{user_id}_memberships",
      target: "membership_#{id}",
      partial: "conversation_memberships/membership",
      locals: { membership: self }
    )
  end

end
