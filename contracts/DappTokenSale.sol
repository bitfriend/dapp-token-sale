pragma solidity ^0.4.17;

import './DappToken.sol';

contract DappTokenSale {
  address admin;
  DappToken public tokenContract;
  uint256 public tokenPrice; // in wei
  uint256 public tokensSold;

  event Sell(address _buyer, uint256 _amount);

  constructor(DappToken _tokenContract, uint256 _tokenPrice) public {
    admin = msg.sender;
    tokenContract = _tokenContract;
    tokenPrice = _tokenPrice;
  }

  function multiply(uint x, uint y) internal pure returns (uint z) {
    require(y == 0 || (z = x * y) / y == x, 'Multiply is incorrect');
  }

  function buyTokens(uint256 _numberOfTokens) public payable {
    require(msg.value == multiply(_numberOfTokens, tokenPrice), 'Value is incorrect');
    require(tokenContract.balanceOf(this) >= _numberOfTokens, 'Lack of balance');
    require(tokenContract.transfer(msg.sender, _numberOfTokens), 'Transfer failed');

    tokensSold += _numberOfTokens;

    emit Sell(msg.sender, _numberOfTokens);
  }

  function endSale() public {
    require(msg.sender == admin, 'Only sender of contract can end contract');
    require(tokenContract.transfer(admin, tokenContract.balanceOf(this)), 'Transfer failed');

    selfdestruct(admin);
  }
}