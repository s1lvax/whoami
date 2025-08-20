class InputComponent < ViewComponent::Base
  def initialize(form:, field:, type: :text, label: nil, autocomplete: nil, autofocus: false, hint: nil, value: nil)
    @form = form
    @field = field
    @type = type
    @label = label || field.to_s.humanize
    @autocomplete = autocomplete
    @autofocus = autofocus
    @hint = hint
    @value = value
  end

  private

  def errors_for(field)
    errs = @form.object.errors[field]
    errs.present? ? errs.join(", ") : nil
  end
end
