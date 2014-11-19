# Publisher (e.g. developer, provisioner)

secret_identity = SecretIdentity.new(
  namespace: 'certmeister',
  name: 'config',
  version: '1'
)
secret = Secret.new(
  identity: secret_identity,
  cleartext: 'The cake is a lie!'
)

storage_provider = VaultS3Provider.new(host: '...', port: '...', authentication: '...')
vault = Vault.new(storage_provider)
key = vault.lock(secret)

=begin
  This might have gotten put in a bucket called "net.auto-h.config-vault:certmeister:config:1",
  in which the object name is taken from the Key.identity (or something).

  This allows each object to be a secret, which allows us to encrypt with a new key without
  mutating existing data.
=end

# Consumer (e.g. application)

=begin
  # How it *could* look, although actors *must* treat keys as opaque, whether serialized or not!
  key = Key.new(identity: '098723-2346234-123978123', creation_time: '...', alg_identifier: '...', kek: '...')
=end
key = Key.from_env('VAULT_KEY')
storage_provider = VaultS3Provider.new(host: '...', port: '...')
vault = Vault.new(storage_provider)

secret_identity = SecretIdentity.new(
  namespace: 'certmeister',
  name: 'config',
  version: '1'
)
secret = vault.unlock(secret_identity, key)
puts secret.cleartext
