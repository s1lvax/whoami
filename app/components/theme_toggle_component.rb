class ThemeToggleComponent < ViewComponent::Base
  def initialize(variant: :global)
    @variant = variant
  end

  private

  attr_reader :variant
end
