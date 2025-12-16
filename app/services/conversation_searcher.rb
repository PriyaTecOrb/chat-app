class ConversationSearcher
  def initialize(user:, query:)
    @user = user
    @query = query.to_s.strip
  end

  def search
    return @user.conversations.recent if @query.blank?

    conversations = @user.conversations
      .joins(:messages)
      .where('messages.content ILIKE ?', "%#{@query}%")
      .or(@user.conversations.where('conversations.title ILIKE ?', "%#{@query}%"))
      .distinct
      .recent

    conversations
  end
end