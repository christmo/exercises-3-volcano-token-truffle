const OZVolcanoCoin = artifacts.require('OZVolcanoCoin');

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract('OZVolcanoCoin', function(accounts) {
  it('should assert true', async function() {
    const instance = await OZVolcanoCoin.deployed();
    let admin = instance.admin.call(accounts[0]);
	console.log(accounts[0]);
    //return assert.isTrue(true);
  });
});
