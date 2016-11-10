require 'openssl'
require 'base64'


#   Handles AES encryption and decryption in a way that is compatible
#   with OpenSSL.
#
#   Defaults to 256-bit CBC encryption, ideally you should leave it
#   this way
#
# ## Basic Usage
#
# ### Encrypting
#
#     cipher = Gibberish.new('p4ssw0rd')
#     cipher.encrypt("some secret text")
#     #=> "U2FsdGVkX1/D7z2azGmmQELbMNJV/n9T/9j2iBPy2AM=\n"
#
# ### Decrypting
#
#     cipher = Gibberish.new('p4ssw0rd')
#     cipher.decrypt(""U2FsdGVkX1/D7z2azGmmQELbMNJV/n9T/9j2iBPy2AM=\n"")
#     #=> "some secret text"
#
# ## OpenSSL Interop
#
#     echo "U2FsdGVkX1/D7z2azGmmQELbMNJV/n9T/9j2iBPy2AM=\n" | openssl enc -d -aes-256-cbc -a -k p4ssw0rd
#
class Gibberish
  KEY = "me*3iE-FKVJS/Sd@"

  attr_reader :password, :cipher

  # Initialize with the password
  #
  # @param [String] password
  def initialize(password)
    @password = password
    @cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
  end

  def encrypt(data)
    setup_cipher(:encrypt, SALT)
    e = cipher.update(data) + cipher.final
    e = "Salted__#{SALT}#{e}" #OpenSSL compatible
    Base64.encode64(e)
  end

  def decrypt(data)
    data = Base64.decode64(data)
    salt = data[8..15]
    data = data[16..-1]
    setup_cipher(:decrypt, salt)
    cipher.update(data) + cipher.final
  end

  private

  SALT = "#{64.chr}#{225.chr}#{169.chr}#{196.chr}#{121.chr}#{36.chr}#{81.chr}#{144.chr}"

  def setup_cipher(method, salt)
    cipher.send(method)
    cipher.pkcs5_keyivgen(password, salt, 1)
  end
end
