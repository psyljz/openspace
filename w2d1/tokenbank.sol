
/*编写一个 TokenBank 合约，可以将自己的 Token 存入到 TokenBank， 和从 TokenBank 取出。

TokenBank 有两个方法：

deposit() : 需要记录每个地址的存入数量；
withdraw（）: 用户可以提取自己的之前存入的 token。 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//@Author liujingze
//@dev withdraw and deposit ERC20 token


import "./IERC20.sol";

contract TokenBank {

    event Deposit(address indexed _from, uint _amount);
    event Withdraw(address indexed _to, uint _amount);
    mapping(address => mapping(address => uint))public AddressToAmount;


    function desposit(address _token_address, uint _amount) public {
        bool result =IERC20(_token_address).transferFrom(msg.sender, address(this), _amount);
        require(result);
        AddressToAmount[msg.sender][_token_address] += _amount;
        emit Deposit(msg.sender, _amount);
    }

    function withdraw(address _token_address, uint _amount) public {
        require(AddressToAmount[msg.sender][_token_address] >= _amount, "InsufficientBalance");

        AddressToAmount[msg.sender][_token_address] -= _amount;
        bool result=IERC20(_token_address).transfer(msg.sender, _amount);
        require(result);
       
        emit Withdraw(msg.sender, _amount);
    }

    function getOneBalance(address _token_address) public view returns(uint) {
        return AddressToAmount[msg.sender][_token_address];
    }
    function getAllowance(address _token_address) public view returns(uint) {
        return IERC20(_token_address).allowance(msg.sender, address(this));
        
    }

    
}