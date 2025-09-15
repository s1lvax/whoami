require "test_helper"

class InputComponentTest < ViewComponent::TestCase
  def render_with_form(object, **kwargs)
    # Create a mock form builder that we can use in tests
    form_builder = ActionView::Helpers::FormBuilder.new(
      object.model_name.param_key,
      object,
      vc_test_controller.view_context,
      {}
    )

    render_inline(InputComponent.new(form: form_builder, **kwargs))
  end

  test "renders a text input with label" do
    user = User.new
    html = render_with_form(user, field: :email, type: :text, label: "Email").to_html
    assert_includes html, "label"
    assert_includes html, "Email"
    assert_includes html, "input"
    assert_includes html, "type=\"text\""
  end

  test "renders a password field" do
    user = User.new
    html = render_with_form(user, field: :password, type: :password, label: "Password").to_html
    assert_match(/type="password"/, html)
  end

  test "renders a text_area" do
    user = User.new
    html = render_with_form(user, field: :bio, type: :text_area, label: "Biography").to_html
    assert_includes html, "textarea"
  end

  test "shows hint text when provided" do
    user = User.new
    html = render_with_form(user, field: :username, type: :text, label: "Username", hint: "Pick something unique").to_html
    assert_includes html, "Pick something unique"
  end

  test "adds error message when field has validation errors" do
    user = User.new(username: "")
    user.validate # triggers validations
    html = render_with_form(user, field: :username, type: :text, label: "Username").to_html
    assert_match(/text-\[var\(--danger\)\]/, html) # CSS error class
    assert_match(/can't be blank/, html)          # error message
  end

  test "merges custom classes and data attributes" do
    user = User.new
    html = render_with_form(
      user,
      field: :email,
      type: :text,
      label: "Email",
      input_options: { class: "custom-class", data: { controller: "x" } }
    ).to_html
    assert_match(/custom-class/, html)
    assert_match(/data-controller="x"/, html)
  end

  test "uses provided value when explicitly set" do
    user = User.new
    html = render_with_form(user, field: :email, type: :text, label: "Email", value: "preset@example.com").to_html
    assert_match(/value="preset@example.com"/, html)
  end
end
