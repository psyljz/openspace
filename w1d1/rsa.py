
"""
Quiz#2
实践非对称加密 RSA(编程语言不限)

先生成一个公私钥对
用私钥对符合 POW 4个开头的哈希值的 “昵称 + nonce” 进行私钥签名
用公钥验证

pip install pycryptodome

"""
# 导入pycryptodome库
from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_OAEP


# 生成RSA密钥对
key = RSA.generate(1024)
pubkey = key.publickey()

# 使用公钥加密数据
message = '刘竞泽81357240239'
cipher = PKCS1_OAEP.new(pubkey)
encrypted_message = cipher.encrypt(message.encode())

print("encrypted_message:",encrypted_message)

# 使用私钥解密数据
cipher = PKCS1_OAEP.new(key)
decrypted_message = cipher.decrypt(encrypted_message)
print(decrypted_message.decode())  # 输出：Hello, world!
