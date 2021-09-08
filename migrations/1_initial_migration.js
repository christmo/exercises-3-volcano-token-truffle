const VolcanoCoinExtropy = artifacts.require("VolcanoCoinExtropy");
const OZVolcanoCoin = artifacts.require("OZVolcanoCoin");

module.exports = function (deployer) {
  deployer.deploy(VolcanoCoinExtropy);
  deployer.deploy(OZVolcanoCoin);
};
