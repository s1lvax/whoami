# frozen_string_literal: true

class Onboarding::UsernameStatusComponent < ViewComponent::Base
  def initialize(status:)
    @status = status || { text: "Type a username…", tone: :muted }
  end

  private

  attr_reader :status

  def classes_for(tone)
    case tone
    when :ok    then "status is-ok"
    when :error then "status is-error"
    else             "status"
    end
  end

  def available?
    status[:tone] == :ok
  end
end
