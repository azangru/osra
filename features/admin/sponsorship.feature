Feature:
  As a member of OSRA staff
  So that I can link sponsors with orphans
  I would like to be able to manage sponsorship relations between sponsors and orphans

  Background:
    Given a sponsor "First Sponsor" exists
    And a sponsor "Second Sponsor" exists
    And the sponsor "First Sponsor" has attribute additional_info "Prefer male orphans from Homs"
    And an orphan "First Orphan" exists
    And an orphan "Second Orphan" exists
    And an orphan "Third Orphan" exists
    And I am a new, authenticated user

  Scenario: Viewing existing sponsorship links between sponsor and orphans
    Given an active sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    And I am on the "Show Sponsor" page for sponsor "First Sponsor"
    Then I should see "1 Currently Sponsored Orphan"
    And I should see "First Orphan"
    When I go to the "Show Orphan" page for orphan "First Orphan"
    Then I should see "Orphan Sponsorship Status" set to "Sponsored"
    And I should see "First Sponsor" linking to the sponsor's page

  Scenario: Sponsorships cannot be created for inactive sponsors
    Given sponsor "First Sponsor" has requested to sponsor 2 orphans
    And the status of sponsor "First Sponsor" is "Inactive"
    When I am on the "Show Sponsor" page for sponsor "First Sponsor"
    Then I should not see the "Link to Orphan" link

  Scenario: Sponsorships cannot be created for sponsors whose requests have been fulfilled
    Given sponsor "First Sponsor" has requested to sponsor 2 orphans
    And an active sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    And an active sponsorship link exists between sponsor "First Sponsor" and orphan "Second Orphan"
    And the status of sponsor "First Sponsor" is "Active"
    When I am on the "Show Sponsor" page for sponsor "First Sponsor"
    Then I should not see the "Link to Orphan" link

  Scenario: Sponsorship can not be created if date is invalid because of an ambiguous or fuzzy match
    Given I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I click the "Link to Orphan" button
    And I fill in Sponsorship Start Date for "First Orphan" with "yesterday"
    When I click the "Sponsor this orphan" link for orphan "First Orphan"
    Then I should see "Start date is invalid"

  Scenario: Sponsorship can not start later than the 1st of next month
    Given I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I click the "Link to Orphan" button
    And I fill in Sponsorship Start Date for "First Orphan" with date in distant future
    When I click the "Sponsor this orphan" link for orphan "First Orphan"
    Then I should see "Start date can not be later than the first of next month"

  Scenario: Pairing a sponsor with orphans
    Given I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I click the "Link to Orphan" button
    Then I should be on the Link to Orphan page for sponsor "First Sponsor"
    And I should see "First Sponsor"
    And I should see "Prefer male orphans from Homs"
    And I should see "First Orphan"
    And I should see "Second Orphan"
    And I fill in Sponsorship Start Date for "First Orphan" with "2014-01-31"
    When I click the "Sponsor this orphan" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    And I should see "Sponsorship link was successfully created"
    And I should see "First Orphan" within "Currently Sponsored Orphans"
    When I click the "Link to Orphan" button
    And I click the "Sponsor this orphan" link for orphan "Second Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    And I should see "Sponsorship link was successfully created"
    And I should see "First Orphan" within "Currently Sponsored Orphans"
    And I should see "Second Orphan" within "Currently Sponsored Orphans"

  Scenario: Ending a sponsorship
    Given "First Sponsor" started a sponsorship for "First Orphan" on "2011-03-15"
    When I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I fill in Sponsorship End Date for "First Orphan" with "2014-03-15"
    And I click the "End sponsorship" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    And I should see "Sponsorship link was successfully terminated"
    And I should not see "First Orphan" within "Currently Sponsored Orphans"
    And I should see "First Orphan" within "Previously Sponsored Orphans"
    And I should see "03/2014" within "Previously Sponsored Orphans"

  Scenario: Ending a sponsorship without provinding an end date
    Given "First Sponsor" started a sponsorship for "First Orphan" on "2011-03-15"
    When I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I fill in Sponsorship End Date for "First Orphan" with ""
    And I click the "End sponsorship" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    And I should see "End date is invalid"

  Scenario: Ending a sponsorship with an end date prior to the start date
    Given "First Sponsor" started a sponsorship for "First Orphan" on "2011-03-15"
    When I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I fill in Sponsorship End Date for "First Orphan" with "2008-01-31"
    And I click the "End sponsorship" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    And I should see "End date can't be before the starting date (2011-03-15)"

  Scenario: Currently sponsored orphans should not be eligible for any new sponsorships
    Given an active sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    And I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I click the "Link to Orphan" button
    Then I should not see "First Orphan"
    When I am on the "Show Sponsor" page for sponsor "Second Sponsor"
    And I click the "Link to Orphan" button
    Then I should not see "First Orphan"

  Scenario: Cancelling sponsorship creation
    Given I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I click the "Link to Orphan" button
    And I click the "Return to Sponsor page" link
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"

  Scenario: A sponsor should be able to re-sponsor an orphan
    Given an inactive sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    And I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I click the "Link to Orphan" button
    Then I should see "First Orphan"
    When I click the "Sponsor this orphan" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    And I should see "Sponsorship link was successfully created"
    And I should see "First Orphan" within "Currently Sponsored Orphans"
    And I should see "First Orphan" within "Previously Sponsored Orphans"

  Scenario: Verifying bug fix for sponsorship inactivation
    Given an inactive sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    And "First Sponsor" started a sponsorship for "First Orphan" on "2011-03-15"
    When I am on the "Show Sponsor" page for sponsor "First Sponsor"
    And I click the "End sponsorship" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    And I should see "Sponsorship link was successfully terminated"

  Scenario: "Request fulfilled" should be automatically set
    Given sponsor "First Sponsor" has requested to sponsor 2 orphans
    And an active sponsorship link exists between sponsor "First Sponsor" and orphan "First Orphan"
    When I am on the "Show Sponsor" page for sponsor "First Sponsor"
    Then I should see "Request Fulfilled" set to "No"
    When an active sponsorship link exists between sponsor "First Sponsor" and orphan "Second Orphan"
    And I am on the "Show Sponsor" page for sponsor "First Sponsor"
    Then I should see "Request Fulfilled" set to "Yes"
    And I should not see the "Link to Orphan" link
    When I fill in Sponsorship End Date for "First Orphan" with date in distant future
    And I click the "End sponsorship" link for orphan "First Orphan"
    Then I should be on the "Show Sponsor" page for sponsor "First Sponsor"
    And I should see "Request Fulfilled" set to "No"
    And I should see the "Link to Orphan" link

  Scenario: Sponsor visible in Orphan list
    Given I am on the "Show Sponsor" page for sponsor "Second Sponsor"
    And I click the "Link to Orphan" button
    Then I should see a New Sponsor panel
    When I click the "All" button
    Then I should not see a New Sponsor panel
    When I click the "Eligible For Sponsorship" button
    Then I should see a New Sponsor panel
    When I click the "Orphans" link
    Then I should not see a New Sponsor panel

  Scenario: Breadcrumbs on orphan list
    Given I am on the "Show Sponsor" page for sponsor "Second Sponsor"
    And I click the "Link to Orphan" button
    Then I should see an Admin Root Path crumb
    And I should see a Sponsors Path crumb
    And I should see a Sponsor Path crumb
    Given I click the "Second Sponsor" link
    Then I should be on the "Show Sponsor" page for sponsor "Second Sponsor"
    Given I click the "Orphans" link
    Then I should not see a Sponsors Path crumb
    And I should not see a Sponsor Path crumb
