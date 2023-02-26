// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ProposalNFT is ERC721Pausable, ERC721URIStorage, Ownable {
    /**
     * @dev
     * - _tokenIdsはCountersの全関数が利用可能
     */
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Voter {
        uint256 weight; // weight is accumulated by delegation
        bool voted; // if true, that person already voted
        address delegate; // person delegated to
        uint256 vote; // index of the voted proposal
    }

    /**
     * @dev
     * - URI設定時に誰がどのtokenIdに何のURIを設定したか記録する
     */
    event TokenURIChanged(
        address indexed sender,
        uint256 indexed tokenId,
        string uri
    );

    constructor() ERC721("ProposalNFT", "PNFT") {}

    /**
     * @dev
     * - このコントラクトをデプロイしたアドレスだけがmint可能 onlyOwner
     * - NFT停止状態の時には実行できない whenNotPaused()
     * - tokenIdをインクリメント _tokenIds.increment()
     * - nftMint関数実行アドレス(=デプロイアドレス)にtokenIdを紐づけ _msgSender()
     * - mintの際にURIを設定　_setTokenURI（）
     * - EVENT発火 emit TokenURIChanged
     */
    function nftMint(address proposerAddress, string memory tokenUri)
        public
        onlyOwner
        whenNotPaused
    {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _mint(proposerAddress, newTokenId);
        _setTokenURI(newTokenId, tokenUri);

        emit TokenURIChanged(proposerAddress, newTokenId, tokenUri);
    }

    /**
     * @dev
     * - NFT停止
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @dev
     * - NFT停止の解除
     */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
     * @dev
     * - オーバーライド
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Pausable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    /**
     * @dev
     * - オーバーライド
     */
    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    /**
     * @dev
     * - オーバーライド
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
