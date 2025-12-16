class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :conversation_memberships, dependent: :destroy
  has_many :conversations, through: :conversation_memberships
  has_many :messages, dependent: :restrict_with_error
  has_many :message_reads, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false },
            format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers and underscores" },
            length: { minimum: 3, maximum: 30 }
  
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  before_validation :generate_username, on: :create
  after_create :create_default_avatar

  scope :online, -> { where('last_seen_at > ?', 5.minutes.ago) }
  scope :recently_active, -> { order(last_seen_at: :desc) }

  def online?
    last_seen_at.present? && last_seen_at > 5.minutes.ago
  end

  def update_last_seen!
    touch(:last_seen_at)
  end

  def display_name
    username || email.split('@').first
  end

  def avatar
    avatar_url.presence || default_avatar_url
  end

  def unread_messages_count
    conversation_memberships.sum(:unread_count)
  end

  private

  def generate_username
    return if username.present?
    
    base = email.split('@').first.parameterize.underscore
    candidate = base
    counter = 1
    
    while User.exists?(username: candidate)
      candidate = "#{base}#{counter}"
      counter += 1
    end
    
    self.username = candidate
  end

  def create_default_avatar
    return if avatar_url.present?
    
    # Use UI Avatars or similar service
    update_column(:avatar_url, "https://ui-avatars.com/api/?name=#{CGI.escape(display_name)}&background=random")
  end

  def default_avatar_url
    "https://ui-avatars.com/api/?name=#{CGI.escape(display_name)}&background=4F46E5&color=fff"
  end
end
