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
        uint projectInPoolId;
    } 

    /// @notice details of projects
    struct ProjectDetails {
        uint projectId;
        uint NGOId;
        string projectDesc;
        uint votes;
        uint amount;
    }

    mapping(uint96 => MatchPoolDetail) public matchPoolDetails;
    mapping(uint => ProjectDetails) public projectDetails;
    mapping(uint => mapping(uint => ProjectDetails)) public projectInMatchPool;

    function fillDetailsofProjects(uint _ngoId, string memory _projectDesc) public {
        _projectIds.increment();
        uint projectId = _projectIds.current();

        projectDetails[projectId] = ProjectDetails(
            projectId,
            _ngoId,
            _projectDesc,
            0,
            0
        );
    }

    function getDetailsofNGOofMatchingPool(uint _ngoId) public {
        MatchPoolDataNGOId = registerAddress.ngoDetails(_ngoId);
    }

    function viewRegisterAddress() public view returns(address) {
        return registerAddress;
    }
}