// SPDX-License-Identifier: MIT
pragma solidity =0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./Register.sol";

contract MatchPoolData {
    using Counters for Counters.Counter;
    Counters.Counter public _projectIds;


    uint public MatchPoolDataNGOId;
    uint96 public MatchPoolProjectCount;

    Register registerAddress;

    constructor (address _registerAddress) public {
        registerAddress = Register(_registerAddress);
    }

    /// @notice details of match pool
    struct MatchPoolDetail {
        uint96 id;
        address matchPoolOwner;
        uint allotedAmount;
        uint48 createdAt;
        ProjectDetails allProjectsInPool;
    } 

    /// @notice details of projects
    struct ProjectDetails {
        uint projectId;
        registerAddress.ngoDetails(MatchPoolDataNGOId);
        string projectDesc;
    }

    mapping(uint96 => MatchPoolDetail) public matchPoolDetails;
    mapping(uint => ProjectDetails) public projectDetails;

    function getDetailsofNGOofMatchingPool(uint _ngoId) public {
        MatchPoolDataNGOId = registerAddress.ngoDetails(_ngoId);
    }

    function viewRegisterAddress() public view returns(address) {
        return registerAddress;
    }
}