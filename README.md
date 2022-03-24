# ExPass Password Manager
Version 0.1

## A highly inefficient (for now) command-line password manager that should not be used for real/actual purposes
Scripted in `bash`

Uses openssl to encrypt password files with AES-256

## Questions
**Why is it inefficient?**

Well, it currently uses multiple decryptions/encryptions with openssl per command which could be optimised to reduce the number to one

**Why is it bad?**

Multiple reasons. First, the key generated is not salted which increases the potential of brute force. Second, it is highly inefficient. Third, it is just bad.

**How does it work?**

It is an index-based system. Seperate password entries are stored as a file and its location is marked by an index file. For decryption, the index is first decrypted to get the location of the encrypted entry and it uses the index to decrypt the entry. 
Key verification sort of works like HMAC where the hash of the generated key is compared to a file which contains the correct hash.