// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
zimport "@openzeppelin/contracts/access/AccessControl.sol";

contract MyToken is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    event CoffeePurchased(address indexed receiver, address indexed buyer); // Index đánh dấu giá trị được lấy từ một hàm

    constructor() ERC20("MyToken", "MTK") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    // Tăng cho address _to 1 lượng tiền bằng _amount
    function mint(address _to, uint256 _amount) public onlyRole(MINTER_ROLE) {
        _mint(_to, _amount * 10 ** decimals());
    }

    function buyOneCoffee() public {
        _burn(_msgSender(), 1 * 10 ** decimals());
        emit CoffeePurchased(_msgSender(), _msgSender());
    }

    function buyOneCoffeeFrom(address _from) public {
        _spendAllowance(_from, _msgSender(), 1 * 10 ** decimals());
        _burn(_from, 1 * 10 ** decimals());
        emit CoffeePurchased(_msgSender(), _from);
    }
}
