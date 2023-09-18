# frozen_string_literal: true

class ExpenseDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all

  def format_date(date)
    date&.strftime('%F - %T')
  end

  def link_to_category
    link_to(category.name.titleize, category)
  end

  def link_to_edit
    link_to(edit_expense_path(self), class: 'btn btn-outline-primary', title: "Update expense #{id}") do
      content_tag(:i, '', class: 'fa fa-pencil-square-o', aria: { hidden: true })
    end
  end

  def modal_button
    content_tag(
      :button,
      content_tag(:i, '', class: 'fa fa-info-circle'),
      class: 'btn btn-outline-info',
      title: "Show expense #{id}",
      data: {
        toggle: 'modal',
        target: "#modal#{id}"
      }
    )
  end
end
