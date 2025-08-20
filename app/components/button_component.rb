
class ButtonComponent < ViewComponent::Base
  def initialize(type: :submit, style: :primary, full_width: true)
    @type = type
    @style = style
    @full_width = full_width
  end

  def classes
    base = "inline-flex justify-center items-center rounded-md px-4 py-2 font-medium focus:outline-none focus:ring-2 transition disabled:opacity-60 disabled:cursor-not-allowed"

    color =
      case @style
      when :primary
        "bg-[var(--btn-bg)] text-[var(--btn-text)] hover:bg-[var(--btn-hover-bg)] cursor-pointer focus:ring-[var(--btn-bg)]"
      when :secondary
        "bg-[var(--muted-bg)] text-[var(--text)] hover:bg-[var(--hover)] cursor-pointer focus:ring-[var(--muted-bg)]"
      else
        ""
      end

    width = @full_width ? "w-full" : ""

    [ base, color, width ].join(" ")
  end
end
