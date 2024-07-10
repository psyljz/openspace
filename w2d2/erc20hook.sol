// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IReceiver.sol";

contract HPToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("HotPot", "HP") {
        _mint(msg.sender, initialSupply);
    }

    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function transferWithCall(
        address to,
        uint amount,
        bytes memory data
    ) public returns (bool result) {
        transfer(to, amount);

        if (isContract(to)) {
            result = IERCRecipient(to).tokensReceived(
                msg.sender,
                amount,
                data
            );
            require(
                result,
                "The contract does not support the ERCRecipient interface"
            );
        }
    }
}
