// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract DegenLink {
    mapping(address => uint) internal recipientAmountMap;
    mapping(address => address) internal senderRecipientMap;

    function addTip(address recipient) external payable {
        if (msg.value == 0) revert();
        recipientAmountMap[recipient] = msg.value;
        senderRecipientMap[msg.sender] = recipient;
    }

    function withdrawTip() external {
        uint amount = recipientAmountMap[msg.sender];
        if (amount == 0) revert();
        recipientAmountMap[msg.sender] = 0;
        address(msg.sender).call{value: amount}("");
    }

    function invalidateTip() external {
        uint amount = recipientAmountMap[senderRecipientMap[msg.sender]];
        recipientAmountMap[senderRecipientMap[msg.sender]] = 0;
        senderRecipientMap[msg.sender] = address(0);
        address(msg.sender).call{value: amount}("");
    }
}
