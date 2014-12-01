Feature: Secret provisioning

  As a developer
  I want to launch my apps in a Docker cloud
  Without baking their secrets into Docker images.

  Scenario: Deploying a brand new application

    Given I have a secret
    And I have a vault
    When I secure the secret in the vault
    Then I get an access card
    And my app can get the secret from the vault with that access card

  Scenario: Partitioning applications from each other

    Given I have secrets secured in a vault:
      | nickname | namespace       | name              | value     |
      | secret1  | app1            | dbpass            | secretXYZ |
      | secret2  | app2            | passphrase        | password1 |
    When I try to use the access card for "secret1" to access "secret2"
    Then I get an error

  Scenario: Using different secrets in different execution environments

    Given I have secrets secured in a vault:
      | nickname | namespace       | name              | value            |
      | prod     | app1:production | dbpass            | jjMXnf28ympt08u5 |
      | staging  | app1:staging    | dbpass            | insecure         |
    When I try to use the access card for "prod" to access "staging"
    Then I get an error

  Scenario: Replacing a secret with a backward compatible value

    Given I have a secret secured in a vault:
      | nickname | namespace       | name              | value            |
      | old      | app1            | dbpass:staging    | insecure         |
    When I secure the secret in the vault with the replacement option:
      | nickname | namespace       | name              | value            |
      | new      | app1            | dbpass:staging    | mxpNge3vCiyynmqt |
    Then the access card for "new" has access to "new"
    And the access card for "old" gets an error

  Scenario: Introducing a secret update that is not backward compatible

    # TODO Come up with a better name than "updating", that reflects preservation of existing value

    Given I have a secret secured in a vault:
      | nickname | namespace       | name              | value            |
      | old      | app1            | cert              | pem:...          |
    When I secure the secret in the vault:
      | nickname | namespace       | name              | value            |
      | new      | app1            | cert              | pfx:...          |
    Then the access card for "new" has access to "new"
    And the access card for "old" still has access to "old"

  Scenario: An old secret is no longer in use

    Given I have secrets secured in a vault:
      | nickname | namespace       | name              | value            |
      | old      | app1            | dbpass:staging    | insecure         |
      | new      | app1            | dbpass:staging    | mxpNge3vCiyynmqt |
    When I invalidate the access card for "old"
    Then the access card for "old" gets an error
    And the access card for "new" still has access to "new"

  Scenario: An access card comes up for renewal but is not suspected of compromise

    Given I have a secret secured in a vault:
      | nickname | namespace       | name              | value            |
      | old      | app1            | dbpass:staging    | insecure         |
    When I secure the secret in the vault with the replacement option:
      | nickname | namespace       | name              | value            |
      | new      | app1            | dbpass:staging    | mxpNge3vCiyynmqt |
    And I make sure all consumers are using the access card for "new"
    And I invalidate the access card for "old"
    Then the access card for "old" gets an error
    And the access card for "new" still has access to "new"

  Scenario: An access card is suspected of compromise

    Given I have a secret secured in a vault:
      | nickname | namespace       | name              | value            |
      | old      | app1            | dbpass:staging    | insecure         |
    When I secure the secret in the vault with the replacement option:
      | nickname | namespace       | name              | value            |
      | new      | app1            | dbpass:staging    | mxpNge3vCiyynmqt |
    And I don't bother to wait for all consumers to be using the access card for "new"
    Then the access card for "new" has access to "new"
    And the access card for "old" gets an error

