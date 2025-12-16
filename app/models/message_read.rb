class MessageRead < ApplicationRecord
  belongs_to :message
  belongs_to :user

  validates :message_id, uniqueness: { scope: :user_id }
  validates :read_at, presence: true

  after_create_commit :broadcast_read_status

  private

  def broadcast_read_status
    broadcast_replace_to(
      message.conversation,
      target: "message_#{message.id}_status",
      partial: "messages/read_status",
      locals: { message: message }
    )
  end
end
