// SPDX-License-Identifier: MIT
pragma solidity =0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin-contracts/contracts/math/SafeMath.sol";

contract Quadratic {
    using SafeERC20 for IERC20;

    using Counters for Counters.Counter;
    Counters.Counter public _ngoIds;
    Counters.Counter public _poolId;
    Counters.Counter public _voterId;

    uint public amount = 0.001 ether;
    // uint public multiplier = amount * 2;

    uint public startTime;
    uint public endTime;
    address public payoutAuthority;
    IERC20 public donationToken;
    bool public hasPaid;

    struct Details {
        uint id;
        string name;
        address dAddress;
    }

    struct ProjectDetails {
        uint id;
        string name;
        address pAddress;
        uint votes;
        Details details;
    }

    struct MatchPool {
        uint poolId;
        address authority;
        uint startTime;
        uint endTime;
        uint amount;
        ProjectDetails pDetails;
    }

    struct Voter {
        address voter;
        uint projectVotedFor;
        uint amount;
        uint count;
    }

    Details[] public NGODetails;
    ProjectDetails[] public projectDetails;
    MatchPool[] public matchPool;
    Voter[] public voters;

    mapping(uint => ProjectDetails) pDetails;

    

    function registerDetails(string memory _name, address _ngoAddress) public {
        _ngoIds.increment();
        uint ngoIds = _ngoIds.current();

        NGODetails[ngoIds] = Details(ngoIds, _name, _ngoAddress);
    }

    function fillProjectDetails(uint _ngoId, uint _nOfprojects, string memory _name, address _pAddress) public {
        require(_nOfprojects > 2, "No of projects should be greater than 2");

        for(uint48 i = 0; i < _nOfprojects; i++) {
            projectDetails[i] = ProjectDetails(
                i,
                _name,
                _pAddress,
                0,
                NGODetails[_ngoId]
            );
        }
    }

    function createPool(address _authority, uint _startTime, uint _endTime, uint _amount, uint _pId) public {
        _poolId.increment();
        uint poolId = _poolId.current();

        matchPool[poolId] = MatchPool(
            poolId,
            _authority,
            _startTime,
            _endTime,
            _amount,
            projectDetails[_pId]
        );
    }

    function voteForProject(uint _voteForProject) public {
        _voterId.increment();
        uint voterId = _voterId.current();
        uint multiplier = 0.001 ether;

        uint voteCount = 0;

        voters[voterId] = Voter(msg.sender, _voteForProject, multiplier, voteCount++);
        pDetails[_voteForProject].votes = voteCount++;

        multiplier++;
    }

    // function calculateAndTransferMoney() public {
    
    // }
}