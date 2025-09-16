# Who Am I

Whoami is a modern, self-hosted personal profile and portfolio platform built with **Rails 8**, **Hotwire**, and **Tailwind CSS**.  
It lets you share your profile, links, CV/experience, and blog posts — all in a sleek, SEO-optimized interface.

---

## ✨ Features

- 🔐 **Authentication** with Devise (email confirmation included)
- 🎨 **Customizable profile** with name, avatar, bio, and links
- 🔗 **Favorite links** with real-time click tracking
- 📄 **Experience / CV** timeline
- ✍️ **Blogging system** with rich text editor
- 📊 **Dashboard** with live stats (profile views, link clicks, blog reads)
- 🌍 **Public profiles** optimized for SEO (title/meta tags, slugs with FriendlyId)
- 📱 Fully responsive, modern UI with Tailwind and custom theme (dark + accent color)
- 📰 **RSS Feed** for every user’s blog posts (`/:username/feed`)
- 📧 **Newsletter subscriptions**: visitors can subscribe to your profile and get your published posts delivered automatically via email

---

## 🚀 Getting Started

### Prerequisites

- Ruby 3.4+
- Rails 8
- SQLite
- Docker & Kamal (for deployment)

### Setup

Clone the repository:

```bash
git clone https://github.com/s1lvax/whoami.git
cd whoami
```

Install dependencies:

```bash
bundle install
```

Setup the database:

```bash
bin/rails db:prepare
```

Run the server:

```bash
bin/dev
```

Visit: [http://localhost:3000](http://localhost:3000)

---

## 🖥️ Deployment

Whoami uses [Kamal](https://kamal-deploy.org) for zero-downtime Docker deployments.

Deploy with:

```bash
bin/kamal deploy
```

---

## 🛠️ Tech Stack

- **Backend**: Ruby on Rails 8, Devise, FriendlyId
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS, custom dark theme
- **Database**: SQLite (default), can be switched to PostgreSQL
- **Editor**: ActionText (Trix) with custom SVG toolbar
- **Deployment**: Kamal + Docker

---

## 📊 Stats Tracking

- Profile visits (ignores self and spammy repeat hits)
- Link clicks (safe + unique tracking)
- Blog post views

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you’d like to change.
Always create branches and submit branches to dev

---

## 📜 License

MIT License. See [LICENSE](LICENSE) for details.

---

## 👤 Author

Made with ❤️ by me (<https://whoami.tech/cfds>)
