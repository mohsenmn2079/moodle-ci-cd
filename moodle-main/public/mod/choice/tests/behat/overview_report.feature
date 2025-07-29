@mod @mod_choice
Feature: Testing overview integration in mod_choice
  In order to summarize the choices made by students
  As a user
  I need to be able to see the choice overview

  Background:
    Given the following "users" exist:
      | username | firstname | lastname |
      | student1 | Student   | 1        |
      | student2 | Student   | 2        |
      | student3 | Student   | 3        |
      | teacher1 | Teacher   | T        |
    And the following "courses" exist:
      | fullname | shortname | enablecompletion |
      | Course 1 | C1        | 1                |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | student1 | C1     | student        |
      | student2 | C1     | student        |
      | student3 | C1     | student        |
      | teacher1 | C1     | editingteacher |
    And the following "activities" exist:
      | activity | name     | intro                | course | idnumber | option             | section | completion | allowmultiple | timeclose      |
      | choice   | Choice 1 | Choice Description 1 | C1     | choice1  | Option 1, Option 2 | 1       | 1          | 1             | 1 January 2040 |
      | choice   | Choice 2 | Choice Description 2 | C1     | choice2  | Option A, Option B | 1       | 0          | 0             |                |
      | choice   | Choice 3 | Choice Description 3 | C1     | choice3  | Option A           | 1       | 0          | 0             |                |
    And the following "mod_choice > responses" exist:
      | choice  | user     | responses          |
      | choice1 | student1 | Option 1, Option 2 |
      | choice1 | student3 | Option 2           |
      | choice2 | student2 | Option A           |

  Scenario: The choice overview report should generate log events
    Given I am on the "Course 1" "course > activities > choice" page logged in as "teacher1"
    When I am on the "Course 1" "course" page logged in as "teacher1"
    And I navigate to "Reports" in current page administration
    And I click on "Logs" "link"
    And I click on "Get these logs" "button"
    Then I should see "Course activities overview page viewed"
    And I should see "viewed the instance list for the module 'choice'"

  Scenario: Students can see relevant columns and content in the choice overview
    Given I am on the "Course 1" "course > activities > choice" page logged in as "student1"
    # Check columns.
    Then I should see "Name" in the "choice_overview_collapsible" "region"
    And I should see "Due date" in the "choice_overview_collapsible" "region"
    And I should see "Status" in the "choice_overview_collapsible" "region"
    And I should see "Responded" in the "choice_overview_collapsible" "region"
    # Check Responded.
    And "Answered" "icon" should exist in the "Choice 1" "table_row"
    And "Answered" "icon" should not exist in the "Choice 2" "table_row"
    # Check allow responses until.
    And the following should exist in the "course-overview-table" table:
      | Name     | Due date       |
      | Choice 1 | 1 January 2040 |
      | Choice 2 | -              |
      | Choice 3 | -              |

  Scenario: Teachers can see relevant columns and content in the choice overview
    Given I am on the "Course 1" "course > activities > choice" page logged in as "teacher1"
    # Check columns.
    Then I should see "Name" in the "choice_overview_collapsible" "region"
    And I should see "Due date" in the "choice_overview_collapsible" "region"
    And I should not see "Status" in the "choice_overview_collapsible" "region"
    And I should see "Students who responded" in the "choice_overview_collapsible" "region"
    And I should see "Actions" in the "choice_overview_collapsible" "region"
    And the following should exist in the "course-overview-table" table:
      | Name     | Students who responded | Actions |
      | Choice 1 | 2                      | View    |
      | Choice 2 | 1                      | View    |
      | Choice 3 | 0                      | View    |

  Scenario: The choice index redirect to the activities overview
    When I log in as "admin"
    And I am on "Course 1" course homepage with editing mode on
    And I add the "Activities" block
    And I click on "Choices" "link" in the "Activities" "block"
    Then I should see "An overview of all activities in the course"
    And I should see "Name" in the "choice_overview_collapsible" "region"
    And I should see "Due date" in the "choice_overview_collapsible" "region"
