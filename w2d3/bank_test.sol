// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Bank} from "../src/Bank.sol";

contract BankTest is Test {
    event Deposit(address indexed user, uint amount);
    // declare the contract under test
    Bank public bank;

    function setUp() public {
        bank = new Bank();
    }

    function test_Deposit_event() public {
        console.log("msg.sender", msg.sender);

        vm.expectEmit(true, false, false, true);
        emit Deposit(address(this), 1);
        bank.depositETH{value: 1}();
    }

    function test_Deposit_balance() public {
        //should be 0 before deposit
        assert(bank.balanceOf(address(this)) == 0);
        uint depositAmount = 1;
        bank.depositETH{value: depositAmount}();
        assert(bank.balanceOf(address(this)) == depositAmount);
    }

    function test_FuzzDeposit_balance(uint256 amount) public {
        vm.assume(amount > 0.1 ether);
        vm.assume(amount < 100 ether);
        //should be 0 before deposit
        assert(bank.balanceOf(address(this)) == 0);
        uint depositAmount = amount;
        bank.depositETH{value: depositAmount}();
        assert(bank.balanceOf(address(this)) == depositAmount);
    }
}
