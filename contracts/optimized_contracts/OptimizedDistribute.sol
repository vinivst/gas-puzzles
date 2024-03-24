// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedDistribute {
    address payable immutable private contributor0;
    address payable immutable private contributor1;
    address payable immutable private contributor2;
    address payable immutable private contributor3;
    uint256 immutable private endTime;

    constructor(address[4] memory _contributors) payable {
        contributor0 = payable(_contributors[0]);
        contributor1 = payable(_contributors[1]);
        contributor2 = payable(_contributors[2]);
        contributor3 = payable(_contributors[3]);
        endTime = block.timestamp + 1 weeks;
    }

    function distribute() external {
        require(
            block.timestamp > endTime,
            "cannot distribute yet"
        );

        uint256 amount;
        unchecked {
            amount = address(this).balance / 4;
        }
        
        contributor0.send(amount);
        contributor1.send(amount);
        contributor2.send(amount);
        selfdestruct(contributor3);
    }
}
