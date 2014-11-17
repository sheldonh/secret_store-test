Feature: Storage

  As an application
  I want to retrieve my secrets
  So that I can use them to do my job

  Scenario: Retrieve a secret

    # XXX Should the alg id of the key select the cipher?
    #     Or should the developer select a cipher?

    Given a stored secret ciphertext
    And I have the identifying details of the secret
    And I have the decryption key
    And I have a cipher
    And I have a storage backend
    When I retrieve the secret
    Then I have the secret cleartext

