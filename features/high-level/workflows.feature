Feature: Secure config provisioning

  As a developer
  I want to configure cloud applications securely
  Without baking their secrets into built images.

  Scenario: Deploying a brand new application

    Given I have a config
    When I secure the config
    And I start the app with the config key
    Then the app gets the config

  Scenario: Partitioning applications from each other

    # Fuck, that's a lot of words.

    Given I have a config for an app called gamma
    And I have a config for an app called epsilon
    When I secure the gamma config
    And I secure the epsilon config
    And I start the gamma app with the gamma config key
    And I start the epsilon app with the epsilon config key
    Then the gamma app gets the gamma config
    And the epsilon app gets the epsilon config
    And the gamma app can't get the epsilon config
    And the epsilon app can't get the gamma config

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

    # This use case is demanding. It wants the key as input to the securing function, or it wants
    # every config update to include updating the key that existing instances will restart with.

    Given I have a version 1 config
    And the config has been secured
    And a running app instance has the key
    And I have an updated version 1 config
    When I secure the updated version 1 config
    And I restart the app instance
    And I start a new app instanc
    Then the old app instance has the updated version 1 config
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
