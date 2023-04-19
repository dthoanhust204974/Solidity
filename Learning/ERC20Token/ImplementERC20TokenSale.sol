//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract ERC20 {
    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) public virtual returns (bool success);

    function decimals() public virtual returns (uint8);
}

contract Owner {
    address owner;
    modifier onlyOwner() {
        require(msg.sender == owner, "Not Allowed");
        _;
    }
}

contract TokenSale {
    uint public tokenPriceInWei = 1 ether;
    ERC20 public token;
    address public owner;

    constructor(address _token) {
        owner = msg.sender; 
        token = ERC20(_token); 
    }

    function purchaseCoffee() public payable {
        require(msg.value >= tokenPriceInWei, "Not Enough");
        uint tokenTransfer = msg.value / tokenPriceInWei;
        uint remainder = msg.value - tokenTransfer * tokenPriceInWei;
        token.transferFrom(
            owner,  // Người sở hữu token
            msg.sender, // Người bán
            tokenTransfer * 10 ** token.decimals()
        );
        payable(msg.sender).transfer(remainder); // Chuyển tiền thừa
    }
}
