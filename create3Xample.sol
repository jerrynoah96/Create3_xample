//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "https://github.com/0xsequence/create3/blob/master/contracts/Create3.sol";


contract ChildContract {
  uint256 initNum;
  address owner;
  
  constructor(uint256 _init) {
    initNum = _init;
    owner = msg.sender;
  }
}

contract Deployer {

  event ChildCreated(address _childContractAddress, string _ChildSalt);


  /// @notice deploys childContract using create3
  /// emits ChildCreated()
  function deployChildContract(string memory _salt) external {
   address _addr = Create3.create3(
      keccak256(bytes(_salt)), 
      abi.encodePacked(
        type(ChildContract).creationCode,
        abi.encode(
          42
        )
      )
    );

    emit ChildCreated(_addr, _salt);
  }


  /// @notice confirms that an address was created by this contract providing a salt,
  function confirmChildContract(address _childContractToVerify, string memory saltString) public view returns(bool){
    bytes32 salt = keccak256(bytes(saltString));
    address _child = Create3.addressOf(salt);
    require(_childContractToVerify == _child, "provided child not created by this contract");
    return true;

  }
}