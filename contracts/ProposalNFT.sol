// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ProposalNFT is ERC721URIStorage, Ownable {
    uint256 private _tokneIdCounter = 0;

    mapping(uint256 => uint256) private _tokenAmount;

    event TokenURIChanged(
        address indexed sender,
        uint256 indexed tokenId,
        string uri
    );

    constructor() ERC721("ProposalNFT", "ISPNFT") {}

    /**
     * 提案NFTの作成
     */
    function mintNft(address proposerAddress, string memory tokenUri, uint256 tokenAmount)
        public
        onlyOwner
    {
        _tokneIdCounter += 1; 
        uint256 newTokenId = _tokneIdCounter;

        _mintAndSetUri(proposerAddress, tokenUri, newTokenId, tokenAmount);
    }

    /**
     * 提案により取得したい金額を設定する
     */ 
    function setTokenAmount(uint256 newTokenId, uint256 tokenAmount) public {
        _tokenAmount[newTokenId] = tokenAmount;
    }

    /**
     * NFTに紐づく調達金額を取得する
     */ 
    function getTokenAmount(uint256 tokenId) public view returns(uint256) {
        return _tokenAmount[tokenId];
    }

    /**
     * NFTを発行しURIを設定する
     */
    function _mintAndSetUri(address proposerAddress, string memory tokenUri, uint256 newTokenId, uint256 tokenAmount) private {
        _mint(proposerAddress, newTokenId);
        _setTokenURI(newTokenId, tokenUri);
        setTokenAmount(newTokenId, tokenAmount);

        emit TokenURIChanged(proposerAddress, newTokenId, tokenUri);
    }

}
