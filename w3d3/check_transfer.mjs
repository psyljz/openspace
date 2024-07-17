import { createPublicClient, http } from 'viem'
import { mainnet } from 'viem/chains'
import { parseAbiItem } from 'viem'
 
export const publicClient = createPublicClient({
  chain: mainnet,
  transport: http("https://eth-mainnet.g.alchemy.com/v2/seOLlSZG2Gi5ZuxZHs9xNlpafdax4u-J")
})


const block_internal=BigInt(100)
const block_end = BigInt(await publicClient.getBlockNumber())
const block_start = BigInt(block_end - block_internal)

const USDC_ADDRESS = '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48'
const logs = await publicClient.getLogs({
    address: USDC_ADDRESS,
    event: parseAbiItem('event Transfer(address indexed from, address indexed to, uint256 value)'),
    fromBlock: block_start, 
    toBlock: block_end
  })

  

function formatTransferData(transferEvents) {
    return transferEvents.map(event => {
      // Convert BigInt to Number and divide by 10^6 for USDC decimal places
      const amount = Number(event.args.value) / 1e6;
      
      return `从 ${event.args.from} 转账给 ${event.args.to} ${amount.toFixed(5)} USDC ,交易ID：${event.transactionHash}`;
    }).join('\n');
  }

    const transfers = formatTransferData(logs)
    console.log(transfers)