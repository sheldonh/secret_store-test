Feature: Secret provisioning

  As a developer
  I want to launch my apps in a Docker cloud
  Without baking their secrets into Docker images.

  Scenario: Deploying a brand new application

    Given I have a secret
    And I have a vault
    When I put the secret in the vault
    Then I get an access card
    And my app can get the secret from the vault with that access card

  Scenario: Partitioning applications from each other

    Given I have two secrets
    And I have a vault
    When I put both secrets in the vault
    Then I get a separate access card for each secret
    And each of my apps can get its secret from the vault with the right access card
    And neither of my apps can get the other app's secret from the vaule with the wrong access card
    
    # WIP up to here with rewrite

  Scenario: Applying different configuration in different execution environments

    # The partition could derive from the environment or the key. Should I nail that down?

    Given I have a staging config
    And I have a production config
    When I secure the staging config
    And I secure the production config
    And I start the app in the staging environment with the staging config key
    And I start the app in the production environment with the production config key
    Then the app in the staging environment gets the staging config
    And the app in the production environment gets the production config
    And the app in the staging environment can't get the production config
    And the app in the production environment can't get the staging config

  Scenario: Upgrading an application to an incompatible config version

    Given I have a version 1 config
    And the config has been secured
    And a running app instance has the key for the version 1 config
    And I have a version 2 config
    When I secure the version 2 config
    And I restart the app instance with the version 1 config key
    And I start a new app instance with the version 2 config key
    Then the old app instance still gets the version 1 config
    And the new app instance gets the version 2 config

  Scenario: Updating the configuration of an application without a config version change

    # Here, we make the bold claim that applications cannot be restarted with an existing key
    # and expect to get an updated configuration.

    Given I have a version 1 config
    And the config has been secured
    And a running app instance has the key
    And I have an updated version 1 config
    When I secure the updated version 1 config
    And I restart the app instance
    And I start a new app instance
    Then the old app instance still gets the old version 1 config
    And the new app instance also has updated version 1 config

  Scenario: Rotating a key that is not yet suspected of compromise

    Given I have a config
    And the config has been secured
    And a running app instance has the key
    When I rotate the key of the config without suspicion of compromise
    And I restart the app instance with the old key
    And I start a new app instance with the new key
    Then the old app instance has the config
    And the new app instance also has the config

  Scenario: Dealing with a lost or stolen key

    Given I have a config
    And the config has been secured
    And a running app instance has the key
    When I rotate the key of the config on suspicion of compromise
    And I restart the app instance with the old key
    And I start a new app instance with the new key
    Then the old app instance does not get the config
    And the new app instance gets the config
