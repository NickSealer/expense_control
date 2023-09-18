# frozen_string_literal: true

module AvatarConcern
  extend ActiveSupport::Concern

  included do
    def attach_avatar(object)
      object.avatar.attach(avatar) if avatar.present? && Expense::IMAGE_TYPES.include?(File.extname(avatar.original_filename))
    end
  end
end
