class Dashboard::StatCardComponent < ViewComponent::Base
  def initialize(label:, value:, delta:, up:)
    @label, @value, @delta, @up = label, value, delta, up
  end
end
