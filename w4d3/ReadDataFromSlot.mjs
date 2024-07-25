import { createPublicClient, http, toHex, encodePacked, keccak256 } from "viem";
import { mainnet } from "viem/chains";

export const publicClient = createPublicClient({
  chain: mainnet,
  transport: http("https://1rpc.io/sepolia"),
});

async function getStorageAt(index) {
  const data = await publicClient.getStorageAt({
    address: "0x95d5950e4Be30BCe7664D852915e537af82b5798",
    slot: index,
  });
  
  return data;
}

const slot_index = keccak256(encodePacked(["uint256"], [0]));

async function parseAndDisplayLocks() {
  // 读取数组的长度
  const length = await getStorageAt(toHex(0));
  const Index_length = Number(length) * 2;

  const locks = [];

  for(let i = 0; i < Index_length; i += 2) {
    const slot1 = await getStorageAt(toHex(BigInt(slot_index) + BigInt(i)));
    const slot2 = await getStorageAt(toHex(BigInt(slot_index) + BigInt(i + 1)));

    const user = '0x' + slot1.slice(26, 66);
    const startTime = parseInt(slot1.slice(10, 26), 16);
    const amount = BigInt(slot2);

    locks.push({
      user,
      startTime,
      amount: amount.toString()  // 转换为字符串以避免BigInt显示问题
    });
  }

  // 显示解析后的数据
  locks.forEach((lock, index) => {
    console.log(`locks[${index}]:`);
    console.log(`user: ${lock.user}`);
    console.log(`startTime: ${lock.startTime}`);
    console.log(`amount: ${lock.amount} (${BigInt(lock.amount) / BigInt(1e18)} ETH)`);
    console.log('---');
  });
}

// 调用函数来解析和显示数据
parseAndDisplayLocks().catch(console.error);


// locks[0]:
// user: 0x0000000000000000000000000000000000000001
// startTime: 3443625288
// amount: 1000000000000000000 (1 ETH)
// ---
// locks[1]:
// user: 0x0000000000000000000000000000000000000002
// startTime: 3443625287
// amount: 2000000000000000000 (2 ETH)
// ---
// locks[2]:
// user: 0x0000000000000000000000000000000000000003
// startTime: 3443625286
// amount: 3000000000000000000 (3 ETH)
// ---
// locks[3]:
// user: 0x0000000000000000000000000000000000000004
// startTime: 3443625285
// amount: 4000000000000000000 (4 ETH)
// ---
// locks[4]:
// user: 0x0000000000000000000000000000000000000005
// startTime: 3443625284
// amount: 5000000000000000000 (5 ETH)
// ---
// locks[5]:
// user: 0x0000000000000000000000000000000000000006
// startTime: 3443625283
// amount: 6000000000000000000 (6 ETH)
// ---
// locks[6]:
// user: 0x0000000000000000000000000000000000000007
// startTime: 3443625282
// amount: 7000000000000000000 (7 ETH)
// ---
// locks[7]:
// user: 0x0000000000000000000000000000000000000008
// startTime: 3443625281
// amount: 8000000000000000000 (8 ETH)
// ---
// locks[8]:
// user: 0x0000000000000000000000000000000000000009
// startTime: 3443625280
// amount: 9000000000000000000 (9 ETH)
// ---
// locks[9]:
// user: 0x000000000000000000000000000000000000000a
// startTime: 3443625279
// amount: 10000000000000000000 (10 ETH)
// ---
// locks[10]:
// user: 0x000000000000000000000000000000000000000b
// startTime: 3443625278
// amount: 11000000000000000000 (11 ETH)
// ---