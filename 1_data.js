var data_contract = artifacts.require("./data.sol");

module.exports = function(deployer){
    deployer.deploy(data_contract);
};