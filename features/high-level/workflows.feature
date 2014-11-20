Feature: Secure config provisioning

  As a developer
  I want to configure cloud applications securely
  Without baking their secrets into built images.

  Scenario: Deploying a brand new application

    Given I have a config
    When I secure the config with a key
    And I start the app with that key
    Then the app gets the config

  Scenario: Partitioning applications from each other

    # Fuck, that's a lot of words.

    Given I have two apps called gamma and epsilon
    And I have a gamma config
    And I have an epsilon config
    When I secure the gamma config with a key
    And I secure the epsilon config with a key
    And I start the app called gamma with the key for the gamma config
    And I start the app called epsilon with the key for the epsilon config
    Then the app called gamma gets the gamma config
    And the app called epsilon gets the epsilon config
    And the app called gamma can't get the epsilon config
    And the app called epsilon can't get the gamme config

  Scenario: Applying different configuration in different execution environments

    # The partition could derive from the environment or the key. Should I nail that down?

    Given I have an app
    And I have a staging config for the app
    And I have a production config for the app
    When I secure the staging config with a key
    And I secure the production config with a key
    And I start the app in the staging environment
    And I start the app in the production environment
    Then the staging app gets the staging config
    And the production app gets the production config

  Scenario: Upgrading an application to an incompatible config version

    Given I have a version 1 config
    And the config has been secured with a key
    And a running app instance has the key for the version 1 config
    And I have a version 2 config
    When I secure the version 2 config with a key
    And I restart the app instance with the version 1 config key
    And I start a new app instance with the version 2 config key
    Then the old app instance still gets the version 1 config
    And the new app instance gets the version 2 config

  Scenario: Updating the configuration of an application without a config version change

    # I think this one demands key as input.

    Given I have a version 1 config
    And the config has been secured with a key
    And a running app instance has the key
    And I have an updated version 1 config
    When I secure the updated version 1 config with a key
    And I restart the app instance
    And I start a new app instanc
    Then the old app instance has the updated version 1 config
    And the new app instance also has updated version 1 config

  Scenario: Rotating a key that is not yet suspected of compromise

    Given I have a config
    And the config has been secured with a key
    And a running app instance has the key
    When I rotate the key of the config without suspicion of compromise
    And I restart the app instance with the old key
    And I start a new app instance with the new key
    Then the old app instance has the config
    And the new app instance also has the config

  Scenario: Dealing with a lost or stolen key

    Given I have a config
    And the config has been secured with a key
    And a running app instance has the key
    When I rotate the key of the config on suspicion of compromise
    And I restart the app instance with the old key
    And I start a new app instance with the new key
    Then the old app instance does not get the config
    And the new app instance gets the config
