//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MappingStructExample {
    struct Transaction {
        uint amout;
        uint timestamp;
    }

    struct Balance {
        uint totalBalance;
        uint numDeposits;
        mapping(uint => Transaction) deposits;
        uint numWithdrawls;
        mapping(uint => Transaction) withdrawls;
    }

    mapping(address => Balance) public balances;

    function getDepositNum(address _from, uint _numDeposit) public view returns(Transaction memory)
    {
        return balances[_from].deposits[_numDeposit];
    }

    function depositMoney() public payable {
        balances[msg.sender].totalBalance += msg.value;

        Transaction memory deposit = Transaction(msg.value, block.timestamp);

        balances[msg.sender].deposits[balances[msg.sender].numDeposits] = deposit;
        balances[msg.sender].numDeposits++;
    }

    
    function getNumDeposit() public view returns(uint)
    {
        return balances[msg.sender].numDeposits;
    }


    // require
    function withdrawlMoney(address payable _to, uint _amount) public  {
        require(_amount<=balances[msg.sender].totalBalance, "Not enough funds, aborting");
        balances[msg.sender].totalBalance -= _amount;
        Transaction memory withdrawl = Transaction(_amount, block.timestamp);
        balances[msg.sender].withdrawls[balances[msg.sender].numWithdrawls] = withdrawl;
        balances[msg.sender].numWithdrawls++;
        _to.transfer(_amount);
    }

    // function getNumWithdrawl() public view return(uint)
    // {
    //     return balances[msg.sender].numWithdrawls;
    // }
}
