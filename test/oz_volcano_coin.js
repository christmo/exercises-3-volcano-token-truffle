const OZVolcanoCoin = artifacts.require('OZVolcanoCoin');

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract('OZVolcanoCoin', function (accounts) {
    it('should assert true', async function () {
        const instance = await OZVolcanoCoin.deployed();
        //let admin = instance.admin.call(accounts[0]);
        console.log(accounts[0]);
        console.log(accounts[1]);
        //console.log(web3.eth.getBalance());
        //console.log(admin.toString());
        //return assert.isTrue(true);
    });

    it('Increase function should be executed by the OWNER only', async () => {
        const _vlc = await OZVolcanoCoin.deployed();
        const owner = accounts[0];
        const oldBalance = await _vlc.totalSupply.call({ from: owner });
        await _vlc._increaseSupply({ from: owner })
        const newBalance = await _vlc.totalSupply.call({ from: owner });
        console.log(`old balance =${oldBalance} , new balance=${newBalance}`)
        assert.equal(newBalance.toString(), '20000', 'OWNER successfuly executed the increaseTotal ')
        // expect(newBalance).to.eq(new BN('1000'))
        // expect(newBalance.eq(BN('2000'))).to.be.true;

    });

    it('Increase function should not be executed by a HACKER', async () => {
        const _vlc = await OZVolcanoCoin.deployed();
        const hacker = accounts[2];
        const oldBalance = await _vlc.totalSupply.call({ from: hacker });
        try {
            await _vlc._increaseSupply({ from: hacker });
        }catch(error){
            //console.log(error.message);
            assert.include(error.message, "caller is not the owner");
        }
        const newBalance = await _vlc.totalSupply.call({ from: hacker });
        console.log(`old balance =${oldBalance} , new balance=${newBalance}`)
        // equal 20000 due to the fact that the change is already done by the owner
        assert.equal(newBalance.toString(), '20000', 'HACKER cannot successfuly executed the increaseTotal ')
    });

});
