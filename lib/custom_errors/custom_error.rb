# frozen_string_literal: true

class CustomError < StandardError
  def initialize(msg = '', errors = [])
    @errors = errors
    super(msg)
  end
end
