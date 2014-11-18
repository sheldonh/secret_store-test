Feature: Storage

  As a developer
  I want to store encrypted application secrets
  So that I don't have to bake secrets into git repos and Docker images.

  Scenario: Store a secret

    # XXX Should the alg id of the key select the cipher?
    #     Or should the developer select a cipher?

    Given I have some secret cleartext
    And I have the identifying details of the secret
    And I have an encryption key
    And I have a cipher
    And I have a storage backend
    When I store the secret
    Then the secret ciphertext is in the storage backend
    And the secret cleartext is not in the storage backend

