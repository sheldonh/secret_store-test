Feature: High level API for locking secrets

  As a developer
  I want to lock a secret and get a secret key
  So that I can configure an application to unlock the secret.

  Scenario: Lock a secret

    Given I have a cleartext secret
    And I have a secret identity
    And I have a vault
    When I lock the secret in the vault
    Then I get back the secret key
    And the encrypted secret has been stored somewhere
    And the secret key can unlock the encrypted secret

Feature: High level API for unlocking secrets

  Scenario: Unlock a secret

    Given I have a vault
    And I have a secret key
    And I have a secret identity
    And the secret key was used to lock a secret with that identity in the vault
    When I unlock the secret
    Then I get back the cleartext secret

