//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Week2 {
    string private name;
    string private symbol;
    uint256 private totalSupply;
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;
    bool private locked;
    address private owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not Allowed");
        _;
    }

    // Khoi tao token
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply,
        address _owner
    ) {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply;
        balances[_owner] = _totalSupply;
        owner = _owner;
    }

    function getBalances() public view returns (uint256) {
        return balances[msg.sender];
    }

    function getTotalSupply() public view returns (uint256) {
        return totalSupply;
    }

    // Burn token
    function burnToken(uint256 _amount) public onlyOwner returns (bool) {
        require(balances[owner] >= _amount, "Insufficient balance");
        balances[owner] -= _amount;
        totalSupply -= _amount;
        return true;
    }

    // Transfer tu dia chi A qua dia chi B
    function transfer(
        address _recipient,
        uint256 _amount
    ) public returns (bool) {
        require(!locked, "Token is locked");
        require(_recipient != address(0), "Transfer to zero address");
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;

        //emit Transfer(msg.sender, _recipient, _amount);

        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) public returns (bool) {
        require(!locked, "Token is locked");
        require(_to != address(0), "Transfer to zero address");
        require(balances[_from] >= _amount, "Insufficient balance");

        balances[_from] -= _amount;
        balances[_to] += _amount;

        //emit Transfer(_from, _to, _amount);
        return true;
    }

    // Lock token

    function lock() public onlyOwner {
        locked = true;
    }

    function unlock() public onlyOwner {
        locked = false;
    }

    // Dinh danh owner, doi owner
    function swapOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }
}
