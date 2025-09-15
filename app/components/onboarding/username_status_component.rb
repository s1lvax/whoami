# frozen_string_literal: true

class Onboarding::UsernameStatusComponent < ViewComponent::Base
  def initialize(status:)
    @status = status || { text: "Type a username…", tone: :muted }
  end

  private

  attr_reader :status

  def classes_for(tone)
    case tone
    when :ok    then "text-sm font-medium text-emerald-400"
    when :error then "text-sm font-medium text-[var(--danger)]"
    else             "text-sm text-[var(--muted)]"
    end
  end

  def available?
    status[:tone] == :ok
  end
end
