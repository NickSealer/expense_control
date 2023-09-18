# frozen_string_literal: true

module NavbarAcctions
  extend ActiveSupport::Concern

  included do
    def years
      @years ||= Expense.where(user_id: current_user.id).select(:year).group(:year).order(:year) if user_signed_in?
    end
  end
end
