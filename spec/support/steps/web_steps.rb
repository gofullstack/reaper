step "I visit :path" do |path|
  visit path
end

step "I should see :text" do |text|
  page.has_content? text
end

step "show me the page" do
  save_and_open_page
end