class Dashboard::SectionComponent < ViewComponent::Base
  def initialize(title:, action_label: nil, action_href: nil, id: nil, count: nil)
    @title = title
    @action_label = action_label
    @action_href = action_href
    @id = id
    @count = count
  end
end
