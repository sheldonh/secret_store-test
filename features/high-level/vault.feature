Feature: High level API (vault)

  As a developer
  I want to lock a secret and get a secret key
  So that I can configure an application to unlock the secret.

  Scenario: Locking a secret

    Given I have a cleartext secret
    And I have a secret identity
    And I have a vault
    When I lock the secret in the vault
    Then I get back the secret key

  Scenario: Secrets are persistent

    Given I have a cleartext secret
    And I have a secret identity
    And I have a vault
    When I lock the secret in the vault
    Then the encrypted secret will be available until deleted

  Scenario: Secrets are unlockable

    Given I have a vault
    And I have a secret key
    And I have a secret identity
    And the secret key was used to lock a cleartext secret with that identity in the vault
    When I unlock the secret
    Then I get back the cleartext secret

  Scenario: Multiply locked secrets

    Given I have a vault
    And I have a secret key
    And I have a secret identity
    And the secret key was used to lock a secret with that identity in the vault
    When I lock a secret with the same identity in the vault
    Then I get back a new secret key
    And the new secret key unlocks the secret
    And the old secret key unlocks the secret

Feature: Portable data

  As an architect
  I want secret keys and encrypted secrets encoded to a well supported public standard
  So that I am not locked into any library provider.

  Scenario: Decrypting an encrypted secret outside the library

    Given I have a cleartext secret
    And I have a secret identity
    And I have a vault
    When I lock the secret in the vault
    And I recover the encrypted secret from the storage back-end
    And I have no knowledge outside the encryptede secret and secret key
    And I decrypt the encrypted secret using the secret key and some standards-based cryptographic library
    Then I get back the cleartext secret
