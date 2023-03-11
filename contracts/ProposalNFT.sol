// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ProposalNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event TokenURIChanged(
        address indexed sender,
        uint256 indexed tokenId,
        string uri
    );

    constructor() ERC721("ProposalNFT", "ISPNFT") {}

    /**
     * @dev
     * 提案NFTを作成
     */
    function nftMint(address proposerAddress, string memory tokenUri)
        public
        onlyOwner
    {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _mint(proposerAddress, newTokenId);
        _setTokenURI(newTokenId, tokenUri);

        emit TokenURIChanged(proposerAddress, newTokenId, tokenUri);
    }
}
