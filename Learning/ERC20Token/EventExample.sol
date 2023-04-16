//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EvenExample {
    mapping(address => uint) public tokenBalances;

    event TokensSent(address _from, address _to, uint _amount);

    constructor() {
        tokenBalances[msg.sender] = 100;
    }

    function sendToken(address _to, uint _amount) public returns (bool) {
        require(tokenBalances[msg.sender] >= _amount, "Not enough tokens");
        tokenBalances[msg.sender] -= _amount;
        tokenBalances[_to] += _amount;

        emit TokensSent(msg.sender, _to, _amount);

        return true;
    }
}
