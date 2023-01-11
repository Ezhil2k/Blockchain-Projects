// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract Lottery {

  address public manager;
  address payable[] public  players;
  address payable winner;

  constructor() {
    manager = msg.sender;
  } 

  modifier onlyOwner{
    require(msg.sender == manager,"You are not the manager");
    _;
  }

  receive() external payable {
    require(msg.value == 1 ether,"pay 0.1 ether to participate" );
    players.push(payable(msg.sender));
  }

  function getBalance() public view onlyOwner returns(uint) {
    return address(this).balance;
  }

  function random(uint num) public view onlyOwner returns(uint) {
    return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,msg.sender))) % num ;
  }

  function pickWinner() public onlyOwner {
    require (players.length >= 3, " Minimum 3 players must be present");
    winner = players[random(players.length) - 1];
    winner.transfer(getBalance());// the random number is sub by 1 as index starts from 0  
  } 

}