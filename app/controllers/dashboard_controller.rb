
class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_onboarded!
  before_action :set_user

  def index
    # Real data from onboarding
    @favorite_links = @user.favorite_links.order(:position, :id)

    # Keep your sample sections (replace with real data later if you want)
    @stats = [
      { label: "Profile Views", value: "2,481", delta: "+12%", up: true },
      { label: "Link Clicks",   value: "613",  delta: "+4%",  up: true },
      { label: "Blog Reads",    value: "188",  delta: "-3%",  up: false },
      { label: "CV Downloads",  value: "27",   delta: "0%",   up: nil }
    ]

    @experiences = [
      {
        company: "whoami.tech",
        role: "Founder & Full-stack Engineer",
        location: "Luxembourg (Remote)",
        start_date: Date.new(2024, 11, 1),
        end_date: nil,
        highlights: [
          "Shipped CV + blog + links platform",
          "Rails 8, Turbo, ViewComponent, Tailwind",
          "Pay (Stripe) subscriptions, Devise auth"
        ],
        tech: %w[Rails Postgres Hotwire Tailwind Stripe]
      },
      {
        company: "ACME Cloud",
        role: "Senior Software Engineer",
        location: "Berlin",
        start_date: Date.new(2022, 3, 1),
        end_date: Date.new(2024, 10, 1),
        highlights: [
          "Led migration to multi-tenant architecture",
          "Cut p95 latency by 38%",
          "Mentored 4 engineers"
        ],
        tech: %w[Ruby Sidekiq Redis Kubernetes]
      }
    ]

    @posts = [
      { title: "Shipping the minimal profile", date: Date.today - 3, views: 128, status: "Published" },
      { title: "Why one accent color",         date: Date.today - 10, views: 245, status: "Published" },
      { title: "Roadmap Q3",                   date: Date.today - 1, views: 0,   status: "Draft" }
    ]

    @billing = {
      plan: "Pro",
      renews_on: 1.month.from_now.to_date,
      status: "Active",
      card_last4: "4242"
    }
  end

  private

  def set_user
    @user = current_user
  end

  def require_onboarded!
    return if current_user.onboarded?
    redirect_to onboarding_path, notice: "Let’s finish setting up your profile first."
  end
end
