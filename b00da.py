import hashlib

def encrypt_string(hash_string):
    sha_signature = \
        hashlib.sha256(hash_string.encode()).hexdigest()
    return sha_signature
    
hash_string = '0' 
while True:
    hash_string = str(int(hash_string) + 1)
    sha_signature = encrypt_string(hash_string)
    if (sha_signature.find('b00da') != -1):
        print(hash_string)
        print(sha_signature)
        break
