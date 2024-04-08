// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract DegenLink {
    mapping(address => uint) internal recipientAmountMap;
    mapping(address => mapping(address => bool)) internal senderRecipientMap;

    function addTip(address recipient) external payable {
        if (msg.value == 0) revert();
        recipientAmountMap[recipient] = msg.value;
        senderRecipientMap[msg.sender][recipient] = true;
    }

    function withdrawTip(address account) external {
        uint amount = recipientAmountMap[account];
        if (amount == 0) revert();
        recipientAmountMap[account] = 0;
        (bool s, ) = address(account).call{value: amount}("");
        if (!s) revert();
    }

    function invalidateTip(address recipient) external {
        uint amount = recipientAmountMap[recipient];
        recipientAmountMap[recipient] = 0;
        if (senderRecipientMap[msg.sender][recipient]) {
            (bool s, ) = address(msg.sender).call{value: amount}("");
            if (!s) revert();
        }
    }
}
