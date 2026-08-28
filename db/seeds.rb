# Demo identity used for local work. Idempotent.

password = "password123"

user = User.find_or_initialize_by(email: "dev@localhost.test")
user.assign_attributes(
  password: password,
  password_confirmation: password,
  name: "Cesário",
  family_name: "Silva",
  username: "cfds",
  bio: "Builds software for people who have to live with it. Rails, quiet interfaces, and the occasional Linux desktop.",
  onboarded: true,
  onboarded_at: Time.current
)
user.skip_confirmation!
user.save!

user.favorite_links.destroy_all
[
  [ "GitHub", "https://github.com/s1lvax", 0 ],
  [ "X", "https://x.com/s1lvax", 1 ],
  [ "Whoami", "https://whoami.tech/cfds", 2 ]
].each do |label, url, position|
  user.favorite_links.create!(label:, url:, position:)
end

user.experiences.destroy_all
user.experiences.create!(
  company: "Silva & Vinha",
  role: "Software",
  location: "Portugal",
  start_date: Date.new(2023, 1, 1),
  end_date: nil,
  highlights: "Ships Rails apps that clinics and kitchens actually use.\nKeeps the stack boring on purpose.",
  tech: "Rails, SQLite, Hotwire, Kamal"
)
user.experiences.create!(
  company: "Whoami",
  role: "Maker",
  location: "Remote",
  start_date: Date.new(2025, 8, 1),
  end_date: Date.new(2025, 9, 16),
  highlights: "A public page for people in tech.\nOpen sourced the hosted app.",
  tech: "Rails, ViewComponent, Postmark"
)

user.posts.each { |post| post.destroy }
post = user.posts.create!(
  title: "The page you put in a GitHub bio",
  excerpt: "A personal site is not a CMS. It is the URL that has to look hired.",
  status: "published",
  send_to_newsletter: false
)
post.update!(body: <<~HTML)
  <div>Most people in tech already have GitHub and LinkedIn. What they do not have is a page that is theirs: one URL, one look, the work in order.</div>
HTML

puts "Seeded #{user.username} / #{user.email} (password: #{password})"
