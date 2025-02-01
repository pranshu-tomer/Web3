const {deployments,ethers,getNamedAccounts} = require('hardhat')
const {assert, expect} = require('chai')
const {developmentChains} = require('../../helper-hardhat-config')

// do same on unit tests
developmentChains.includes(network.name) ? describe.skip :
describe("FundMe", async function() {
    let FundMe
    let deployer
    const sendValue = ethers.utils.parseEther("1")
    beforeEach(async function() {
        deployer = (await getNamedAccounts()).deployer
        FundMe = await ethers.getContract("FundMe",deployer)
    })

    it("allows people to fund and withdraw", async function() {
        let fundAmount = sendValue
        await FundMe.fund({value: fundAmount})
        await FundMe.withdraw()
        const endBalance = await FundMe.provider.getBalance(FundMe.address)
        assert.equal(endBalance.toString(), "0")
    })
})