// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract InnovationSupportFT is ERC20, Ownable {

    // デポジットとして入金する額: 1token = 1千円として50,000千円入金する
    uint256 private constant depositAmmount = 50 * 1000;

    constructor() ERC20("InnovationSupportFT", "ISFT"){
        mint(msg.sender, depositAmmount);
    }

    /**
     * URI設定時に誰がどのtokenIdに何のURIを設定したか記録する
     */
    event TokenMint(
        address indexed sender,
        uint256 indexed ammount
    );

    /**
     * 指定したアドレスにトークンを発行
     */
    function mint(address senderAddress, uint256 amount )
        private
    {
        _mint(senderAddress, amount);
        emit TokenMint(senderAddress, amount);
    }

    /**
     * 指定したアドレスのトークンを焼却
     */
    function burn(address senderAddress, uint256 amount )
        public
        onlyOwner
    {
        _burn(senderAddress, amount);
    }

    /**
     * オーナーににトークンを発行
     */
    function mintDeposit() 
        public
        onlyOwner
    {
        mint(owner(), depositAmmount);
    }

    /**
     * @dev
     * デポジットされているトークン量を取得
     */
    function balanceOfDeposit() public view virtual returns (uint256) {
        return balanceOf(owner());
    }
}