// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract DegenLink {
    mapping(bytes32 => uint256) hashAmountMap;
    mapping(bytes32 => address) internal recipientHashMap;
    mapping(address => mapping(address => bool)) internal senderRecipientMap;

    function addTip(address recipient, bytes32 hash) external payable {
        if (msg.value == 0) revert();
        hashAmountMap[hash] = msg.value;
        recipientHashMap[hash] = recipient;
    }

    function withdrawTip(address account, string calldata uid) external {
        bytes32 hash = keccak256(abi.encode(uid));
        uint amount = hashAmountMap[hash];
        if (amount == 0) revert();
        hashAmountMap[hash] = 0;
        (bool s, ) = address(account).call{value: amount}("");
        if (!s) revert();
    }

    function invalidateTip(address recipient, string calldata uid) external {
        bytes32 hash = keccak256(abi.encode(uid));
        uint amount = hashAmountMap[hash];
        hashAmountMap[hash] = 0;
        if (recipient != address(0)) {
            (bool s, ) = address(msg.sender).call{value: amount}("");
            if (!s) revert();
        }
    }
}
