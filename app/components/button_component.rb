class ButtonComponent < ViewComponent::Base
  def initialize(type: :submit, style: :primary, full_width: true, name: nil)
    @type = type
    @style = style
    @full_width = full_width
    @name = name
  end

  def classes
    style = case @style
    when :primary then "btn-primary"
    when :secondary then "btn-secondary"
    else ""
    end

    [ "btn", style, (@full_width ? "btn-block" : nil) ].compact.join(" ")
  end
end
