# Lexicon

There is some gnarly terminology in here. I'm not happy with what I have yet.

* `Vault` - an abstraction over a storage provider and cryptographic provider.
  This is the primary abstraction of the high-level API.
  `Actors` use it to `lock` and `unlock` `secrets`, which it does by handling persistence, encryption, decryption and encoding opaquely.
  * `Lock` - the `vault` function of encrypting and storing a secret.
    It returns a `secret key`.
  * `Unlock` - the `vault` function of retrieving and decrypting a secret.
    It returns the `cleartext secret`.
* `Actor` - a person, application, role or group of same.
* `Secret` - namespaced, named and versioned data intended to be known to only some `actors`, and unknown to others.
  May refer to the data in unencrypted form (the `cleartext secret`) or encrypted form (the `encrypted secret`).
* `Secret identity` - a tuple of the namespace, name and version of a `secret`:
  * `Secret namespace` - container for a set of secrets that are all intended for disclosure to the same `actors`.
    Namespaces provide granularity for access control when writing (and possibly reading) secret ciphertext.
  * `Secret name` - the identity of a single secret in a namespace, unique within that namespace.
    Names allow a single access control policy to apply to multiple secrets.
  * `Secret version` - a sequential identifier for the state of a named secret at some moment in time.
    Versions allow secrets to evolve out of lockstep with key distribution.
* `Cleartext secret` - the data of a `secret` in unencrypted form as intended to be known by participating actors.
* `Encrypted secret` - a package of data required by an `actor` in posession of the `secret key` to derive the `secret cleartext`.
  May include not only `ciphertext`, but also metadata required to initialize the decryption function.
  In terms of the Cryptographic Message Syntax, this is the [enveloped-data](http://tools.ietf.org/html/rfc5652#section-6) content type.
* `Secret key` - the package of data that must be known to an `actor` in posession of an `encrypted secret` to derive the `secret cleartext`.
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

To avoid lexical clash between the storage back-end and the high-level API, I'm looking for alternative words for "store" and "retrieve"
to use in the high-level API. Some ideas:

* store: hide, keep, protect, lock
* retrieve: reveal, disclose, divulge, unlock

### Panic

With the current design, when your configuration changes because of environmental pressure (rather than because new code needs new config),
you have to get the new secret key out into the wild. That doesn't feel right. Need to sleep on it, but this suggests that the idea of
taking key generation inside the vault's lock function might be going one step too far.

## Storage

Not sure where to express this, but the index path to an encrypted secret will be:

```
namespace -> name -> version -> encrypted_secret_uuid
```

Although CMS allows a single enveloped-data to specify multiple recipients, I don't want to go through the head-ache of mutating
encrypted secrets by appending recipients to them. I'd rather just keep adding (and deleting by version for maintenance,
and by key\_id for responding to key compromise).

So I'd like to resist using the key\_id in the index path to a secret, forcing the library to iterate over all encrypted secrets for a
`secret identity` to find one that can be decrypted with the key in hand. This will keep the option for multi-recipients enveloped-data
later.

I'm not sure how we'll map this comfortably onto S3. Including `version` in the S3 bucket name forces us to grant publishing `actors`
broad rights; they have to be able to create buckets. If we can use ACLs to "allow to create any bucket, but only write buckets we
created", we'll probably be okay.
