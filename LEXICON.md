# Lexicon

There is some gnarly terminology in here. I'm not happy with what I have yet.

* `Vault` - an abstraction over a storage provider and cryptographic provider.
  This is the primary abstraction of the high-level API.
  `Actors` use it to `secure` and `access` `secrets`, which it does by handling persistence, encryption, decryption and encoding opaquely.
  * `Secure` - the `vault` function of encrypting and storing a `secret`.
    It returns an `access card`.
  * `Access` - the `vault` function of retrieving and decrypting a `secret`.
    It returns the `cleartext secret`.
* `Actor` - a person, application, role or group of same.
* `Secret` - uniquely identified data intended to be known to only some `actors`, and unknown to others.
  Has a `secret identity`.
  May refer to the data in unencrypted form (the `cleartext secret`) or encrypted form (the `encrypted secret`).
* `Secret identity` - a tuple of the namespace and name of a `secret`:
  * `Secret namespace` - container for a set of secrets that are all intended for disclosure to the same `actors`.
    Namespaces provide granularity for access control when writing (and possibly reading) secret ciphertext.
  * `Secret name` - the identity of a single secret in a namespace, unique within that namespace.
    Names allow a single access control policy to apply to multiple secrets.
* `Cleartext secret` - the data of a `secret` in unencrypted form as intended to be known by participating actors.
* `Encrypted secret` - a package of data required by an `actor` in posession of the `access card` to derive the `secret cleartext`.
  May include not only `ciphertext`, but also metadata required to initialize the decryption function.
  In terms of the Cryptographic Message Syntax, this is the [enveloped-data](http://tools.ietf.org/html/rfc5652#section-6) content type.
* `Access card` - the package of data that must be known to an `actor` in posession of an `encrypted secret` to derive the `secret cleartext`.
  `Actors` must regard the data as an opaque blob. That said, it is likely to contain things like
  * a unique key identifier,
  * the creation time of the key,
  * an encryption algorithm identifier and
  * the key.
  When public-key cryptography is used, the key contained in this opaque blob is the private key of the asymmetric key pair.
  When symmetric-key cryptography is used, it is the key encryption key that was used to wrap the content encryption key that
  actually encrypted the `cleartext secret`.
* `Ciphertext` - the output of a `cipher` applied to a `cleartext secret`.
* `Cipher` - an algorithm for encrypting and decrypting, i.e. transforming between `secret cleartext` or `secret ciphertext`.
  Although vitally important to the security of secrets, cipher selection should be hidden from developers by the library,
  which is designed to express strongly, our opinions about good security.

## Worries

It might be a mistake to try to abstract CMS language here. I should introduce the idea of enveloped data into the lexicon.

With the current design, when your configuration changes because of environmental pressure (rather than because new code needs new config),
you have to get the new access card out into the wild. Ernst and I don't feel that is is too much of a burden. At the point where you
want live processes to respond to configuration changes, you'll need some mechanism for notification of change; since you're already talking
to those processes for this purpose, it's not a stretch to demand that one of the things you say to them is "here is a new access card".

## Storage

Not sure where to express this, but the index path to an encrypted secret will be:

```
namespace -> name -> dictionary
			key_id -> encrypted_secret
			key_id -> encrypted_secret
			...
```

Although CMS allows a single enveloped-data to specify multiple recipients, I don't want to go through the head-ache of mutating
encrypted secrets by appending recipients to them. I'd rather just keep adding (and deleting by key\_id for maintenance and
responding to key compromise).

So I'd like to resist using the key\_id in the index path to a secret, forcing the library to iterate over all encrypted secrets for a
`secret identity` to find one that can be decrypted with the key in hand. This will keep the option for multi-recipients enveloped-data
later.

## Ideas

An alternative idea for indexing encrypted secrets, is that each encrypted secret has a UUID. We imprint this UUID on the access card,
and it is the primary index to the secret. We add auxiliary indexes of `namespace:name` and `key_id`, for auditing and maintenance.

I need time to play with the idea. On the one hand, it feels right that an access card identify the encrypted secret it accesses.
But I need to think through how it impacts on the option to add asymetric-key cryptography later.

