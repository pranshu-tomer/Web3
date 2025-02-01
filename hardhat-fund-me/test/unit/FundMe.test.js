const {deployments,ethers,getNamedAccounts} = require('hardhat')
const {assert, expect} = require('chai')

describe("FundMe", async function() {
    let FundMe
    let deployer
    let mockV3Aggregator
    const sendValue = ethers.utils.parseEther("1")
    beforeEach(async function() {
        deployer = (await getNamedAccounts()).deployer
        await deployments.fixture(["all"])
        FundMe = await ethers.getContract("FundMe",deployer)
        mockV3Aggregator = await ethers.getContract("MockV3Aggregator",deployer)
    })
    describe("constructor", async function() {
        it("sets the aggregator addresses correctly", async function() {
            const priceFeedAddress = await FundMe.priceFeed()
            assert.equal(priceFeedAddress,mockV3Aggregator.address)
        })
    })

    describe("fund", async function() {
        it("Fails if you don't sent enough ETH", async function() {
            await expect(FundMe.fund()).to.be.reverted
        })
        it("update the amount funded data structure", async function() {
            await FundMe.fund({value: sendValue})
            const result = await FundMe.addressToAmountFunded(deployer)
            assert.equal(result.toString(),sendValue.toString())
        })
        it("update the funders array", async function() {
            await FundMe.fund({value: sendValue})
            const result = await FundMe.funders(0)
            assert.equal(result,deployer)
        })
    })

    describe("withdraw", async function() {
        beforeEach(async function(){
            await FundMe.fund({value: sendValue})
        })
        it("Withdraw ETH from a single funder", async function() {
            const startingBalanceFundMe = await FundMe.provider.getBalance(FundMe.address)
            const startingBalanceDeployer = await FundMe.provider.getBalance(deployer)
            const response = await FundMe.withdraw()
            const receipt = await response.wait(1)
            const {gasUsed, effectiveGasPrice} = receipt
            const gasCost = gasUsed.mul(effectiveGasPrice)

            const endingBalanceFundMe = await FundMe.provider.getBalance(FundMe.address)
            const endingBalanceDeployer = await FundMe.provider.getBalance(deployer)

            assert.equal(endingBalanceFundMe.toString(),"0")
            assert.equal(endingBalanceDeployer.add(gasCost).toString(),startingBalanceDeployer.add(startingBalanceFundMe).toString())

        })
        it("allows us to withdraw with multiple funders", async function() {
            const accounts = await ethers.getSigners()
            for(let i = 1; i < 6; i++) {
                const account = accounts[i]
                await FundMe.connect(account).fund({value: sendValue})
            }
            const startingBalanceFundMe = await FundMe.provider.getBalance(FundMe.address)
            const startingBalanceDeployer = await FundMe.provider.getBalance(deployer)
            const response = await FundMe.withdraw()
            const receipt = await response.wait(1)
            const {gasUsed, effectiveGasPrice} = receipt
            const gasCost = gasUsed.mul(effectiveGasPrice)

            const endingBalanceFundMe = await FundMe.provider.getBalance(FundMe.address)
            const endingBalanceDeployer = await FundMe.provider.getBalance(deployer)

            assert.equal(endingBalanceFundMe.toString(),"0")
            assert.equal(endingBalanceDeployer.add(gasCost).toString(),startingBalanceDeployer.add(startingBalanceFundMe).toString())
        
            // Funders are reset properly
            await expect(FundMe.funders(0)).to.be.reverted
            for(i = 1; i < 6; i++) {
                assert.equal(await FundMe.addressToAmountFunded(accounts[i].address),0)
            }
        })
        it("only allows the owner to withdraw", async function(){
            const accounts = ethers.getSigners()
            const attacker = accounts[1]
            const attackerConnectedContract = await FundMe.connect(
                attacker
            )
            await expect(attackerConnectedContract.withdraw()).to.be.reverted
        })

    })
})