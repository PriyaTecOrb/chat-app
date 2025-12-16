class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true

  validates :file_name, :file_type, :url, presence: true

  def image?
    file_type.starts_with?('image/')
  end

  def video?
    file_type.starts_with?('video/')
  end

  def document?
    ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'].include?(file_type)
  end

  def humanized_size
    ActiveSupport::NumberHelper.number_to_human_size(file_size)
  end
end
