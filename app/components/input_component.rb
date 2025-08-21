class InputComponent < ViewComponent::Base
  def initialize(form:, field:, type:, label: nil, autocomplete: nil, autofocus: false, value: nil, hint: nil, input_options: {})
    @form = form
    @field = field
    @type = type
    @label = label
    @autocomplete = autocomplete
    @autofocus = autofocus
    @value = value
    @hint = hint
    @input_options = input_options || {}
  end

  private

  def error_text_for(field)
    obj = @form&.object
    return nil unless obj.respond_to?(:errors)
    msgs = obj.errors.full_messages_for(field)
    msgs.first
  end
end
