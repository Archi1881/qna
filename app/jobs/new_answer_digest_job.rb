class NewAnswerDigestJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerDigestService.new.send_notification(answer)
  end
end
