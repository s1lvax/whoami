class InputComponent < ViewComponent::Base
  def initialize(form:, field:, type:, placeholder: nil, label: nil, autocomplete: nil, autofocus: false, value: nil, hint: nil, input_options: {})
    @form = form
    @field = field
    @type = type
    @placeholder = placeholder
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
    obj.errors.full_messages_for(field).first
  end

  # Map component `type` to the actual Rails FormBuilder method
  def form_method_name
    t = @type.to_s
    case t
    when "text_area" then :text_area
    when "file"      then :file_field
    else
      :"#{t}_field"  # text_field, email_field, password_field, number_field, etc.
    end
  end
end
