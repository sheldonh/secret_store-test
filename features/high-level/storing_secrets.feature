Feature: High level API for locking secrets

  As a developer
  I want to lock a secret and get a secret key
  So that I can configure an application to unlock the secret.

  Scenario: Lock a secret

    Given I have a cleartext secret
    And I have a secret namespace
    And I have a secret name
    And I have a secret version
    When I lock the secret
    Then I get back the secret key
    And the encrypted secret has been stored somewhere
    And the secret key can unlock the encrypted secret

Feature: High level API for unlocking secrets

  Scenario: Unlock a secret

    Given an encrypted secret has been stored somewhere
    And I have the secret namespace
    And I have the secret name
    And I have the secret version
    And I have the secret key
    When I unlock the secret
    Then I get back the cleartext secret

