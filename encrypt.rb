require "openssl"
require "digest"
require "base64"
require 'securerandom'

def aes128_encrypt(key, data)
  key = Digest::MD5.digest(key) if(key.kind_of?(String) && 16 != key.bytesize)
  aes = OpenSSL::Cipher.new('AES-128-CBC')
  aes.encrypt
  aes.key = key
  aes.update(data) + aes.final
end
 
def aes256_encrypt(key, data)
  key = Digest::SHA256.digest(key) if(key.kind_of?(String) && 32 != key.bytesize)
  aes = OpenSSL::Cipher.new('AES-256-CBC')
  aes.encrypt
  aes.key = key
  Base64.encode64(aes.update(data) + aes.final)
end
 
def aes128_decrypt(key, data)
  key = Digest::MD5.digest(key) if(key.kind_of?(String) && 16 != key.bytesize)
  aes = OpenSSL::Cipher.new('AES-128-CBC')
  aes.decrypt
  aes.key = key
  aes.update(data) + aes.final
end
 
def aes256_decrypt(key, data)
  key = Digest::SHA256.digest(key) if(key.kind_of?(String) && 32 != key.bytesize)
  aes = OpenSSL::Cipher.new('AES-256-CBC')
  aes.decrypt
  aes.key = key
  Base64.decode64(aes.update(data) + aes.final)
end

def encrypt_pass(username, pass)
  @key = SecureRandom.hex
  #encrypted_pass = aes256_encrypt(key, pass)
  encrypted_pass = Base64.encode64(pass)

  puts "Opening file and replacing creds"
  target = File.open('./creds.rb', 'w')

  target.write("$username = '#{username}'")
  target.write("\n")
  target.write("$password = '#{encrypted_pass}'")
  target.write("\n")
  target.write("$key = '#{@key}'")
  target.write("\n")
  target.write("$creds_encrypted = true")

  #puts aes256_decrypt($key, encrypted_pass)
  return encrypted_pass
end

def decrypt_pass(pass)
  Base64.decode64(pass)
end
