// SPDX-License-Identifier:MIT

/**
 *Submitted for verification at Etherscan.io on 2024-07-04
 url: https://sepolia.etherscan.io/address/0x9c1377790460ae90d4f2172e457d3983640b4914#code
*/
pragma solidity ^0.8.8;

/// @author liujingze
/// @dev small bank

/*
1. Deposit money into the bank.
2. The bank owner can withdraw all funds.
3. Record each address's deposited funds.
4. Store the amounts of funds deposited by the top three addresses in an array.
*/

contract SmallBank {
    mapping(address => uint) AddressToAmount;
    address payable public BANK_OWER;
    uint public ThirdFundAmount = 0;

    address[] public TopThreeAddress = new address[](3);

    uint public MAX_AMOUNT;
    uint public MID_AMOUNT;
    uint public MIN_AMOUNT;

    constructor() {
        BANK_OWER = payable(msg.sender);
    }

    function withdraw() public {
        require(msg.sender == BANK_OWER);
        BANK_OWER.transfer(address(this).balance);
    }

    function deposited() public payable {
        AddressToAmount[msg.sender] += msg.value;

        calTopUser(AddressToAmount[msg.sender], msg.sender);
    }

    function calTopUser(uint amount, address user_address) private {
        if (amount < MIN_AMOUNT) {
            return;
        }

        if (MIN_AMOUNT < amount && amount <= MID_AMOUNT) {
            MIN_AMOUNT = amount;
            TopThreeAddress[2] = user_address;
            return;
        }

        if (MID_AMOUNT < amount && amount <= MAX_AMOUNT) {
            if (TopThreeAddress[1] != user_address) {
                MIN_AMOUNT = MID_AMOUNT;
                TopThreeAddress[2] = TopThreeAddress[1];
                MID_AMOUNT = amount;
            } else {
                MID_AMOUNT = amount;
            }

            TopThreeAddress[1] = user_address;
            return;
        }
        if (amount > MAX_AMOUNT) {
            if (TopThreeAddress[0] != user_address) {
                MIN_AMOUNT = MID_AMOUNT;
                TopThreeAddress[2] = TopThreeAddress[1];
                MID_AMOUNT = MAX_AMOUNT;
                TopThreeAddress[1] = TopThreeAddress[0];
                MAX_AMOUNT = amount;
            } else {
                MAX_AMOUNT = amount;
            }
            TopThreeAddress[0] = user_address;
            return;
        }
    }
}
