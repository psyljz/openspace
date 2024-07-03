// SPDX-License-Identifier:MIT

/// @author liujingze
/// @dev simple add function

pragma solidity ^0.8;


contract Counter {

    uint counter;

    function get() public view returns(uint) {

        return counter;
    }

    function add (uint _number) public {

        counter=counter + _number;
        
    }


}

