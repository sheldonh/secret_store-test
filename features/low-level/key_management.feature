@developer
Feature: Key management

  As a developer
  I want to manage content encryption keys
  So that I can encrypt each application's secrets independently

  Scenario Outline: Keys are usable

    Given a symmetric cipher
    When I request a content encryption key for the cipher
    Then the cipher can decrypt what it encrypts with the key

    Examples:
      | cipher      |
      | AES-256-CBC |
      | 3DES-CBC    |

  Scenario Outline: Keys match the cipher they were created for

    Given a symmetric cipher
    When I request a content encryption key for the cipher
    And the key has the right length
    And the key has the name of the cipher it is intended for use with

    Examples:
      | cipher      | key_length |
      | AES-256-CBC | 256        |
      | 3DES-CBC    | 168        |

  Scenario: Keys have unique identities

    Given a symmetric cipher
    When I request one content encryption key for the cipher
    And I request another content encryption key for the cipher
    Then the two keys have different identities

  Scenario: Keys expose their age

    Given a symmetric cipher
    When I request a content encryption key for the cipher
    Then the key has the current data and time as its issue time

  Scenario: Keys are serializable

    Given a content encryption key
    When I save the key to a file to illustrate serialization
    And I load the key from a file to illustrate deserialization
    Then the loaded key is identical to the key I saved

