// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.14;

contract ProposalVote {
    // 投票者
    struct Voter {
        bool agreement;
        bool voted;
    }

    // 提案
    struct Proposal {
        address proposerAddress;
        uint voteTotalCount;
        uint voteAgreementCount;
        uint8 votingStatus;
        mapping(address => Voter) voters;
    }

    // 投票状態(enum)
    uint8 private voting = 0 ; 
    uint8 private accept = 1 ; 
    uint8 private reject = 2 ; 

    // TokenIdに提案を紐づける
    mapping(uint256 => Proposal) public proposals;

    // 外部コントラクトのアドレス
    address private _tokenContractAddress;
    address private _nftContractAddress;

    constructor() {
    }

    function setTokenContractAddress(address tokenContractAddress) external {
        _tokenContractAddress = tokenContractAddress;
    }

    function getTokenContractAddress() external view returns (address){
        return _tokenContractAddress;
    }

    function setNftContractAddress(address nftContractAddress) external {
        _nftContractAddress = nftContractAddress;
    }

    function getNftContractAddress() external view returns (address){
        return _nftContractAddress;
    }

    /**
     * 投票題目を作成する
     */
    function entryProposal(address proposerAddress, uint256 proposalNftTokenId) public {
        Proposal storage proposal = proposals[proposalNftTokenId];

        // addressの初期値=address(0)なのでそれと等しくない場合は、登録済みの提案とする
        require(proposal.proposerAddress == address(0), "This proposal is already registered.");
        
        proposal.proposerAddress = proposerAddress;
        proposal.voteTotalCount = 0;
        proposal.voteAgreementCount = 0;
        proposal.votingStatus = voting;
    }

    /**
     * 投票を実行する
     */
    function vote(uint256 proposalNftTokenId, address voterAddress, bool judgement ) public {
        Proposal storage proposal = _proposalExists(proposalNftTokenId);

        Voter storage voter = proposal.voters[voterAddress];
        require(!voter.voted, "You already voted.");

        voter.agreement = judgement;
        voter.voted = true;

        proposals[proposalNftTokenId].voteTotalCount += 1;

        // 承認の場合、承認者数を1増やす
        if(judgement){
            proposals[proposalNftTokenId].voteAgreementCount += 1;
        }
    }

    /**
     * 提案の状態を可決(accept)か反対(reject)に変更する
     */
    function judgementProposal(uint256 proposalNftTokenId, bool finalJudgement) public
    {
        Proposal storage targetProposal = _proposalExists(proposalNftTokenId);
        require(targetProposal.votingStatus == 0, "This proposal has already been resolved.");

        targetProposal.votingStatus = finalJudgement ? accept : reject;

        // if(finalJudgement){ // 可決された場合NFTの所有者にトークンを発行する
        //     address tokenContractAddress = IProposalNFT(_nftContractAddress).ownerOf(proposalNftTokenId);
        //     IInnovationSupportFT(_tokenContractAddress).transfer(tokenContractAddress, 1);
        // }
    }

    /**
     * 投票に対して賛成した数を取得する
     */
    function getAgreement(uint256 proposalNftTokenId) public view returns(uint256){
        Proposal storage proposal = _proposalExists(proposalNftTokenId);
        
        return proposal.voteAgreementCount;
    }

    /**
     * 提案が存在する場合はそれを返し、存在しな場合はエラーを返す。
     */ 
    function _proposalExists(uint proposalNftTokenId) private view returns(Proposal storage){
        Proposal storage proposal = proposals[proposalNftTokenId];
        require(proposal.proposerAddress != address(0), "This proposal is not registered.");
        return proposal;
    } 
}

/**
 * トークンコントラクトのインターフェース
 */
interface IInnovationSupportFT {
    function transfer(address to, uint256 amount) external returns (bool);
}

/**
 * 提案NFTコントラクトのインターフェース
 */
interface IProposalNFT {
    function ownerOf(uint256 tokenId) external returns (address owner);
}