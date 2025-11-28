// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
// MegaETH Timothy Testnet (Chain ID 6343) - MVP EchoChain

contract EchoChain {
    address public owner;
    uint256 public echoCount = 0;
    string public constant VERSION = "MVP - Timothy Testnet (6343)";

    event Echo(uint256 indexed echoId, address indexed from, uint256 timestamp);

    constructor() {
        owner = msg.sender;
    }

    function createEcho() external {
        echoCount++;
        emit Echo(echoCount, msg.sender, block.timestamp);
    }

    function getVersion() external pure returns (string memory) {
        return VERSION;
    }
}
