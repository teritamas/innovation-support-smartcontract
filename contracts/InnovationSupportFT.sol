// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract InnovationSupportFT is ERC20 {

    constructor() ERC20("InnovationSupportFT", "ISFT"){
        mint(msg.sender, 1000 * 1000 * 2000);
    }

    /**
     * @dev
     * - URI設定時に誰がどのtokenIdに何のURIを設定したか記録する
     */
    event TokenMint(
        address indexed sender,
        uint256 indexed ammount
    );

    /**
     * @dev
     * 指定したアドレスにトークンを発行
     */
    function mint(address senderAddress, uint256 amount )
        public
    {
        _mint(senderAddress, amount);
        emit TokenMint(senderAddress, amount);
    }

    /**
     * @dev
     * 指定したアドレスのトークンを焼却
     */
    function burn(address senderAddress, uint256 amount )
        public
    {
        _burn(senderAddress, amount);
    }
}