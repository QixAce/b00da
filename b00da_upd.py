import hashlib
import string
import random

def encrypt_string(hash_string):
    sha_signature = \
        hashlib.sha256(hash_string.encode()).hexdigest()
    return sha_signature
    
hash_string = random.choice(string.ascii_letters)
while True:
    hash_string = hash_string + random.choice(string.ascii_letters)
    sha_signature = encrypt_string(hash_string)
    if len(hash_string) > 16:
        hash_string = random.choice(string.ascii_letters)
    if (sha_signature.find('b00da') != -1):
        print(hash_string)
        print(sha_signature)
        break
