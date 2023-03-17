# innovation-support-smartcontract

TOYOTAWeb3ハッカソンで開発した、イノベーションサポートで利用するスマートコントラクトです。

## デプロイ方法

1. [Remix](https://remix.ethereum.org/#lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.18+commit.87f61d96.js)で本リポジトリをCloneする。
2. `InnovationSupportFT.sol`、`ProposalNFT.sol`をデプロイする
3. `InnovationSupportFT.sol`、`ProposalNFT.sol`で`transferOwnership`実行し、所有者をイノベーションサポートの管理者ウォレットに変更する。
4. `ProposalVote.sol`をデプロイする
5. `ProposalVote.sol`の下記の関数をそれぞれ実行し、`InnovationSupportFT.sol`、`ProposalNFT.sol`を紐づける
    - `setNftContractAddress(${ProposalNFT.solのコントラクトアドレス})`
    - `setERC20ContractAddress(${InnovationSupportFT.solのコントラクトアドレス})`


## 各コントラクトの概要
 
### `InnovationSupportFT.sol`
 
イノベーションサポートで通貨として利用できるトークンの発行、移転、償却を行うコントラクト。ERC20を遵守している。
 
### `ProposalNFT.sol`
 
イノベーションサポート上で投稿した提案内容を、NFT化するコントラクト.ERC721を遵守している。
 
### `ProposalVote.sol`

`ProposalNFT`と`InnovationSupportFT.sol`（ERC20）と連携し、NFTに対する投票処理と、NFTの所有者に投票結果に応じてトークンを支払う。支払うトークンはERC20のトークンであれば、任意のトークンを発行可能である。

