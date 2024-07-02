""""

Quiz#1
实践 POW 编写程序（编程语言不限）用自己的昵称 + nonce不断修改nonce 进行 sha256 Hash 运算：

直到满足 4 个 0 开头的哈希值打印出花费的时间、Hash 的内容及Hash值。
再次运算直到满足 5 个 0 开头的哈希值打印出花费的时间、Hash 的内容及Hash值。

"""

import hashlib
import time
import random

MAX_TRY=100000000

HASH_ZERO =4

time_start=time.time()

while True:

    nonce =random.randint(1,100000000000)
    data = "刘竞泽"+str(nonce)

    data_output =hashlib.sha256(data.encode("utf-8")).hexdigest()
    if data_output[:HASH_ZERO] =="0"*HASH_ZERO:

        time_end=time.time()
        time_cost=time_end-time_start

        print("time cost:",time_cost,"s")
        print("hash_data:",data)
        print("hash_output:",data_output)
        
        exit()




