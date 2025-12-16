class UserPresenceJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user

    user.update_last_seen!

    # Broadcast presence to all active conversations
    user.conversations.each do |conversation|
      PresenceChannel.broadcast_to(
        conversation,
        {
          user_id: user.id,
          username: user.display_name,
          online: true,
          last_seen_at: user.last_seen_at
        }
      )
    end
  end
end