// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyWallet {
    string public name;
    mapping(address => bool) private approved;

    // 使用常量来定义 owner 存储槽的位置
    bytes32 private constant OWNER_SLOT = keccak256("thisowneraddress");

    constructor(string memory _name) {
        name = _name;
        _setOwner(msg.sender);
    }

    modifier auth {
        require(_getOwner() == msg.sender, "Not authorized");
        _;
    }

    function transferOwnership(address _newOwner) public auth {
        require(_newOwner != address(0), "New owner is the zero address");
        require(_getOwner() != _newOwner, "New owner is the same as the old owner");
        _setOwner(_newOwner);
    }

    function _setOwner(address _newOwner) private {

        assembly {
            sstore(OWNER_SLOT, _newOwner)
        }

    }

    function _getOwner() private view returns (address owner) {
        assembly {
            owner := sload(OWNER_SLOT)
        }
    }

    function getOwner() public view returns (address) {
        return _getOwner();
    }
}