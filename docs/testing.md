# Testing

Minitest, fixtures, no RSpec, no factories.

```bash
bin/rails test                     # everything (~300 runs, a few seconds)
bin/rails test test/components     # one directory
bin/rails test test/controllers/subscriptions_controller_test.rb:70   # one test
```

## Layout

| Directory | What lives there |
|---|---|
| `test/components/` | One file per ViewComponent, mirroring `app/components/`. They render with `render_inline` and assert on markup with Nokogiri / Capybara matchers. When you change a template, expect to update its test — that is the point of them. |
| `test/controllers/` | Request specs per controller, including the custom-domain constraint, the public availability check, in-place subscribe (Turbo Stream) and the cable broadcast on confirm (`ActionCable::TestHelper#assert_broadcasts`). |
| `test/integration/` | Registration flow, including the handle claimed on the landing page. |
| `test/models/`, `test/mailers/`, `test/jobs/` | The usual. Mailer previews in `test/mailers/previews/`. |
| `test/system/` | Empty on purpose. Headless Chrome is configured (`test/application_system_test_case.rb`) if you want browser tests. |

Fixtures: `test/fixtures/*.yml`. `users(:one)` is the onboarded user most tests lean on.

## CI

`.github/workflows/ci.yml` runs three jobs on pull requests and pushes to `main`: Brakeman, `bin/importmap audit`, and the test suite (`bin/rails db:test:prepare test test:system`).

## Lint and security

```bash
bin/rubocop          # rubocop-rails-omakase; `-a` to autocorrect
bin/brakeman --no-pager
```

## Screenshots

Handy when reviewing design changes. Headless Chromium follows the desktop's colour scheme, so to control the theme drive Chrome through Selenium (already in the bundle) and emulate the media feature:

```ruby
driver.execute_cdp("Emulation.setEmulatedMedia",
  features: [{ name: "prefers-color-scheme", value: "light" }])
```

For full-page captures use CDP `Page.captureScreenshot` with `captureBeyondViewport: true` (Selenium's `save_screenshot` only grabs the viewport). Logged-in pages: fill `#user_email` / `#user_password` on `/users/sign_in` first.

## Known flake

Two test processes sharing `storage/test.sqlite3` can raise `SQLite3::BusyException: database is locked`. Run one suite at a time.
