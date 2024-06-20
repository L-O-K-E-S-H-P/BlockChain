// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Lottery
{
   
  address public manager;
  address payable[]  public players;
  address payable public winner;

  constructor()
  {
    manager=msg.sender;
  }

  function participate() public payable
  {
    require(msg.value==1 ether,"Please pay 1 ether only");
    players.push(payable(msg.sender));
  }

  function getBalanace() public view returns(uint)
  {
    require(manager==msg.sender,"Only authorized Manager can access");
    return address(this).balance;
  }
  function random() internal view returns (uint) {
    return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
}

  function pickWinner() public payable
  {
    require(manager==msg.sender,"Only authorized Manager can access");
    require(players.length>=2,"Players are less than 3");

    uint r = random();
    uint index=r%players.length;
    winner=players[index];
    winner.transfer(getBalanace());
    players=new address payable[](0);

  }

}

