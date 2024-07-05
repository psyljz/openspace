//SPDX-License-Identifier:MIT
pragma solidity ^0.8.8;

/// @author liujingze
/// @dev small bank

/*
1. Deposit ether should more than 0.001.(modifier)
2. bankowner can be transfer.
3. transfer owner to Ownable contract .
4. only owner can withdraw fund.
5. Store the amounts of funds deposited by the top three addresses in an array.
*/

interface Ibank {
    function withdraw() external;

    function transferOwnerShip(address _new_owner) external;
}

contract Bank is Ibank {
    address payable public BANK_OWNER;

    constructor() {
        BANK_OWNER = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == BANK_OWNER);
        _;
    }

    function transferOwnerShip(address _new_owner) public onlyOwner {
        BANK_OWNER = payable(_new_owner);
    }

    function withdraw() public onlyOwner {
        BANK_OWNER.transfer(address(this).balance);
    }
}

contract BigBank is Bank {

    modifier depositeBar() {
        require(msg.value >= 0.001 ether);
        _;
    }

    constructor() Bank() {}

    mapping(address => uint) public AddressToAmount;

    address[] public TopThreeAddress = new address[](3);

    function deposited() public payable depositeBar {
        AddressToAmount[msg.sender] += msg.value;

        calTopUser(AddressToAmount[msg.sender], msg.sender);
    }

    function calTopUser(uint _amount, address _user_address) private {
        if (_amount < AddressToAmount[TopThreeAddress[2]]) {
            return;
        }

        if (
            AddressToAmount[TopThreeAddress[2]] < _amount &&
            _amount <= AddressToAmount[TopThreeAddress[1]]
        ) {
            TopThreeAddress[2] = _user_address;
            return;
        }

        if (
            AddressToAmount[TopThreeAddress[1]] < _amount &&
            _amount <= AddressToAmount[TopThreeAddress[0]]
        ) {
            if (TopThreeAddress[1] != _user_address) {
                TopThreeAddress[2] = TopThreeAddress[1];
            }

            TopThreeAddress[1] = _user_address;
            return;
        }
        if (_amount > AddressToAmount[TopThreeAddress[0]]) {
            if (TopThreeAddress[0] != _user_address) {
                TopThreeAddress[2] = TopThreeAddress[1];

                TopThreeAddress[1] = TopThreeAddress[0];
            }

            TopThreeAddress[0] = _user_address;
            return;
        }
    }
}

contract Ownable {
    function withdraw(address _bank_address) public {
        Ibank(_bank_address).withdraw();
    }

    function transferOwnerShip(
        address _bank_address,
        address _new_owner
    ) public {
        Ibank(_bank_address).transferOwnerShip(_new_owner);
    }

    receive() external payable {}
}
