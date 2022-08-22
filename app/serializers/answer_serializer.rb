class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :user_id

  has_many :links
  has_many :comments
  has_many :files
  belongs_to :user
  belongs_to :question

  def files
    object.files.map do |file|
      { url: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) }
    end
  end