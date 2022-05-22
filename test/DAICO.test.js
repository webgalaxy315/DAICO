const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const provider = ganache.provider();
const web3 = new Web3(provider);
const {interface, bytecode} = require('../compile');

let daico;
let accounts;

beforeEach(async() => {
  accounts = await new web3.eth.getAccounts();
  daico = await new web3.eth.Contract(JSON.parse(interface))
  .deploy({data: bytecode})
  .send({from: accounts[0], gas: '1000000'});
});

describe('Test DAICO contract', ()  =>  {
  it('deploy DAICO contract', ()  =>  {
    assert.ok(daico.options.address);
  });
});
