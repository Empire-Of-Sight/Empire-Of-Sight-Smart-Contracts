/// SPDX-License-Identifier: Unveiled Tech License

/// 2023 Unveiled Tech. All rights reserved.

/// This smart contract and any part thereof, including but not limited to the source code,
/// documentation, and any associated artifacts, may not be used, copied, modified,
/// sublicensed, or distributed, in whole or in part, without the express written
/// permission of Unveiled Tech.

/// ██    ██ ███    ██ ██    ██ ███████ ██ ██      ███████ ██████      ████████ ███████  ██████ ██   ██
/// ██    ██ ████   ██ ██    ██ ██      ██ ██      ██      ██   ██        ██    ██      ██      ██   ██
/// ██    ██ ██ ██  ██ ██    ██ █████   ██ ██      █████   ██   ██        ██    █████   ██      ███████
/// ██    ██ ██  ██ ██  ██  ██  ██      ██ ██      ██      ██   ██        ██    ██      ██      ██   ██
///  ██████  ██   ████   ████   ███████ ██ ███████ ███████ ██████         ██    ███████  ██████ ██   ██

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Reward is ERC1155Holder, Ownable, ReentrancyGuard {
    IERC1155 public immutable token;

    mapping(address => bool) internal validators;
    address internal validator;

    event RewardClaimed(address indexed claimer, uint256 indexed id);
    event RewardValidated(address indexed claimer, uint256 indexed id);

    constructor() {
        token = IERC1155(0x4EC3E1086CE46a8f8Af28db4FcfeCF2D51De337b);
        validator = 0x947E0Cc54fB2a758Ab605da79aa6317D26A8A355;
        validators[validator] = true;
    }

    modifier onlyValidator() {
        require(
            validators[msg.sender] || owner() == msg.sender,
            "Not validator"
        );
        _;
    }

    function addValidator(address validatorAddress) external onlyOwner {
        validators[validatorAddress] = true;
    }

    function removeValidator(address validatorAddress) external onlyOwner {
        validators[validatorAddress] = false;
    }

    function getContractBalance(uint256 id) public view returns (uint256) {
        return token.balanceOf(address(this), id);
    }

    function claimReward(uint256 id) external nonReentrant {
        emit RewardClaimed(msg.sender, id);
    }

    function validateReward(
        address to,
        uint256 id,
        uint256 amount
    ) external onlyValidator {
        require(to != address(0), "Invalid address");
        require(amount > 0, "Amount must be greater than 0");
        require(
            token.balanceOf(address(this), id) >= amount,
            "Insufficient balance"
        );
        token.safeTransferFrom(address(this), to, id, amount, "");

        emit RewardValidated(to, id);
    }

    function withdrawAdmin(uint256 id, uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than 0");
        require(
            token.balanceOf(address(this), id) >= amount,
            "Insufficient balance"
        );
        token.safeTransferFrom(address(this), owner(), id, amount, "");
    }
}
