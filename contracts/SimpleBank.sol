pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; // ADDED: ERC-20 interface

contract SimpleBank {

    IERC20 public token; // ADDED: PYUSD token handle

    mapping (address => uint) private balances;
    mapping (address => bool) private enrolled;
    address private owner;

    event LogEnrolled(address accountAddress);
    event LogDepositMade(address accountAddress, uint amount);
    event LogWithdrawal(address accountAddress, uint amount, uint newBalance);

    constructor(address _pyusd) public {          // CHANGED: accept token address
        owner = msg.sender;
        token = IERC20(_pyusd);                   // ADDED
    }

    function enroll() public returns (bool) {
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
        return enrolled[msg.sender];
    }

    function deposit(uint amount) public returns (uint) {                 // CHANGED: not payable
        require(token.transferFrom(msg.sender, address(this), amount));    // ADDED
        balances[msg.sender] += amount;
        emit LogDepositMade(msg.sender, amount);
        return balances[msg.sender];
    }

    function withdraw(uint withdrawAmount) public returns (uint) {
        require(withdrawAmount <= balances[msg.sender]);
        balances[msg.sender] -= withdrawAmount;
        require(token.transfer(msg.sender, withdrawAmount));               // CHANGED
        emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
        return balances[msg.sender];
    }

    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
}