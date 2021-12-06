// SPDX-License-Identifier: MIT
pragma solidity =0.8.0;

import "./Register.sol";
import "./MatchPoolData.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";

contract MatchPool {
    using SafeERC20 for IERC20;

    MatchPoolData matchPoolDataAddress;

    uint public startTime;
    uint public endTime;
    address public payoutAuthority;
    IERC20 public donationToken;
    bool public hasPaid;


    struct Voter {
        address voter;
        uint amount;
        uint count;
        bool hasDonated;
    }

    mapping(bool => Voter) public hasVoterDonated;

    constructor(address _payoutAuthority, address _matchPoolDataAddress) {
        payoutAuthority = _payoutAuthority;
        matchPoolDataAddress = MatchPoolData(_matchPoolDataAddress);
    }

    function provideMatchingPoolAmount(uint _amount) internal {
        IERC20(donationToken).safeTransferFrom(address(payoutAuthority), address(matchPoolDataAddress), _amount);
    }

    // function voteInMatchPoolRound(uint96 _matchpoolId, uint _projectId, uint _amount) public {
    //     require(block.timestamp > startTime && block.timestamp < endTime, "voting over");
    //     uint vote = 1;
    //     uint amount = _amount;
    //     matchPoolDataAddress.matchPoolDetails[_matchpoolId][_projectId].push(,,, vote, amount);
    // }


    // function getRegisterAddress(address _registerAddress) public {
    //     registerAddress = _registerAddress;
    // }
}