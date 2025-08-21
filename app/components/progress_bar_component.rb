
# frozen_string_literal: true

require "securerandom"

class ProgressBarComponent < ViewComponent::Base
  def initialize(percent:, step: nil, total_steps: nil, label: nil, animate: true, id: nil)
    @percent = [ [ percent.to_i, 0 ].max, 100 ].min
    @step = step
    @total_steps = total_steps
    @label = label
    @animate = animate
    @uid = id.presence || "progress-#{SecureRandom.hex(6)}"
  end

  attr_reader :uid

  def percent = @percent
  def animate? = @animate

  private

  def caption
    @label || (@step && @total_steps ? "Step #{@step} of #{@total_steps}" : "#{@percent}%")
  end
end
