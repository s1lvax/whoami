class Dashboard::ActivityItemComponent < ViewComponent::Base
  def initialize(title:, detail:)
    @title, @detail = title, detail
  end
end
