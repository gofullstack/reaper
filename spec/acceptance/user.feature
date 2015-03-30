Feature: User
  Scenario: Visit the home page
    When I visit "/"
    Then I should see "app_name"

  Scenario: Visit the invoices page
    When I visit "/invoices"
    Then I should see "app_name"