const ProposalVote = artifacts.require("../contracts/ProposalVote.sol");
const ProposalNFT = artifacts.require("../contracts/ProposalNFT.sol");
const InnovationSupportFT = artifacts.require(
  "../contracts/InnovationSupportFT.sol"
);

module.exports = async function (deployer) {
  await deployer.deploy(ProposalNFT);
  const proposalNFT = await ProposalNFT.deployed();

  await deployer.deploy(InnovationSupportFT);
  const innovationSupportFT = await InnovationSupportFT.deployed();

  await deployer.deploy(ProposalVote);
  const proposalVote = await ProposalVote.deployed();

  // 提案コントラクトに2つのコンんトラクトを登録
  let accounts = await web3.eth.getAccounts();
  await proposalVote.setNftContractAddress(proposalNFT.address, {
    from: accounts[0],
  });
  await proposalVote.setERC20ContractAddress(innovationSupportFT.address, {
    from: accounts[0],
  });
};
