//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// You may not modify this contract or the openzeppelin contracts
contract NotRareToken is ERC721 {
    mapping(address => bool) private alreadyMinted;

    uint256 private totalSupply;

    constructor() ERC721("NotRareToken", "NRT") {}

    function mint() external {
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
        alreadyMinted[msg.sender] = true;
    }
}

contract OptimizedAttacker {
    constructor(address victim) {
        new HackedAttacker().batchMint(NotRareToken(victim));
    }
}

contract HackedAttacker {
    uint256 tokenId;

    function batchMint(NotRareToken _notRareToken) external {
        for (uint256 i; i < 150; i++) {
            _notRareToken.mint();
        }
        
        for (uint256 i; i < 150; i++) {
            _notRareToken.transferFrom(address(this), tx.origin, tokenId++);
        }
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 _tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        if (tokenId == 0) {
            tokenId = _tokenId;
        }
        return IERC721Receiver.onERC721Received.selector;
    }
}
