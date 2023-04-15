//SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

contract Consumer {
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function deposit() public payable {}
}

contract SmartContractWallet {
    address payable public owner;
    mapping(address => uint) public balances;
    mapping(address => bool) public isAllowedToSend;
    mapping(address => bool) public guardians;
    mapping(address => mapping(address => bool)) nextOwnerGuardianVoteBool;
    address payable nextOwner;
    uint guardianResetCount;
    uint constant confirmationCount = 3;

    constructor() {
        owner = payable(msg.sender);
    }

    //
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not Owner, Can not do this!");
        _;
    }
    modifier onlyGuardian() {
        require(guardians[msg.sender], "");
        _;
    }

    //
    function setBalances(address _for, uint _amount) public onlyOwner {
        balances[_for] = _amount;
        if (_amount > 0) {
            isAllowedToSend[_for] = true;
        } else {
            isAllowedToSend[_for] = false;
        }
    }

    function setGuardian(address _guardian) public onlyOwner {
        guardians[_guardian] = true;
    }

    //
    function proposeNewOwner(address payable _newOwner) public onlyGuardian {
        require(
            nextOwnerGuardianVoteBool[_newOwner][msg.sender],
            "You already voted"
        );
        if (_newOwner != nextOwner) {
            nextOwner = _newOwner;
            guardianResetCount = 0;
        }
        guardianResetCount++;
        if (guardianResetCount >= confirmationCount) {
            owner = _newOwner;
            _newOwner = payable(address(0));
        }
    }

    function transfer(
        address payable _to,
        uint _amount,
        bytes memory _payload
    ) public returns (bytes memory) {
        if (msg.sender != owner) {
            require(
                isAllowedToSend[msg.sender],
                "You are not allowed to send anything."
            );
            require(
                balances[msg.sender] >= _amount,
                "You are trying to send more than you are allowed to transfer"
            );

            balances[msg.sender] -= _amount;
        }
        (bool success, bytes memory returnData) = _to.call{value: _amount}(
            _payload
        );
        require(success, "Aborting, call was not successful");
        return returnData;
    }

    receive() external payable {}
}
