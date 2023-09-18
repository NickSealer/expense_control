# frozen_string_literal: true

class CategoryDeleteMailerJob
  include Sidekiq::Job
  sidekiq_options queue: 'mailers', retry: 2

  def perform(user_id, category_id)
    user = User.find_by(id: user_id)
    category = Category.find_by(id: category_id)

    MailMailer.category_delete(user, category).deliver_now
  end
end
