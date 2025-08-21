class Dashboard::ProfileHeaderComponent < ViewComponent::Base
  def initialize(profile:, edit_href: nil)
    @profile    = profile
    @edit_href  = edit_href
  end
end
