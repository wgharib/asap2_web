class Fu < ActiveRecord::Base

  belongs_to :project, :optional => true

  # Variables
  FU_STATUSES = %w(new uploading uploaded)

  # Validations
  #  validates :name, presence: true
  validates :status, inclusion: { in: FU_STATUSES } 

  # Paperclip
  has_attached_file :upload, url: "/data/:class/:id/:filename"
  do_not_validate_attachment_file_type  :upload #, content_type: { content_type: ['text/plain'] }
#  validates_attachment :upload, content_type: { content_type: ['application/zip', 'application/pdf', 'text/plain'] }

  def to_jq_upload(error=nil)
    {
      files: [
        {
          name: read_attribute(:upload_file_name),
          size: read_attribute(:upload_file_size),
          url: upload.url(:original),
          delete_url: Rails.application.routes.url_helpers.fu_path(self),
          delete_type: "DELETE" 
        }
      ]
    }
  end

  def upload_done?
    status.in? %w(uploaded) 
  end
end
