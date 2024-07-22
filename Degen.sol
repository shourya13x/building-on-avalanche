// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    using Strings for uint256;

    struct Item {
        string name;
        uint256 redeemAmount;
    }

    mapping(uint256 => Item) public items;
    mapping(address => mapping(uint256 => uint256)) public redeemedItems;

    constructor() ERC20("Crypto", "CRT") Ownable(msg.sender) {
        items[1] = Item("Novice Navigator", 1000);
        items[2] = Item("Mythic Maverick", 1110);
        items[3] = Item("Celestial Crushe", 2000);
        items[4] = Item("Astral Acet", 1500);
        items[5] = Item("Divine Dominato", 3600);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function burn(uint256 amount) public override {
        _burn(_msgSender(), amount);
    }

    function showStore() external pure returns (string memory) {
        return "1. Novice Navigator(1000 CRT) 2. Mythic Maverick(1110 CRT) 3. Celestial Crushe(2000 CRT) 4.  Astral Acet(1500 CRT) 5. Divine Dominat (3600 CRT)";
    }

    function redeem(uint256 itemId, uint256 quantity) external {
        require(quantity > 0, "Quantity must be greater than zero");

        Item storage selectedItem = items[itemId];
        require(bytes(selectedItem.name).length > 0, "Invalid item");
        require(balanceOf(msg.sender) >= selectedItem.redeemAmount * quantity, "Insufficient balance");

        _burn(msg.sender, selectedItem.redeemAmount * quantity);

        redeemedItems[msg.sender][itemId] += quantity;
    }

    function getRedeemedItems(address user) external view returns (string memory) {
        string memory result = "";
        for (uint256 i = 1; i <= 5; i++) {
            if (redeemedItems[user][i] > 0) {
                string memory item = items[i].name;
                string memory quantity = redeemedItems[user][i].toString();
                result = string(abi.encodePacked(result, item, ": ", quantity, " items\n"));
            }
        }
        return result;
    }
}