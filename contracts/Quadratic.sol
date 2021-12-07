// SPDX-License-Identifier: MIT
pragma solidity =0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin-contracts/contracts/math/SafeMath.sol";

contract Qaudratic {
    using Counters for Counters.Counter;
    Counters.Counter public _ngoIds;

    uint public payoutAmount;
    address public payoutAuthority;
    uint public numOfProject;
    uint public startTime;
    uint public endTime;
    IERC20 public donationToken;

    struct Details {
        uint256 id;
        string name;
        address dAddress;
    }

    struct ProjectDetails {
        uint id;
        string name;
        address pAddress;
        uint balance;
        uint voteCount;
        Details details;
        // mapping(address => bool) hasvoted;
    }

    struct MatchPool {
        uint poolId;
        address authority;
        uint startTime;
        uint endTime;
        uint amount;
        ProjectDetails pDetails;
        // mapping(uint => ProjectDetails[]) pDetails;
    }

    struct Voter {
        // address voter;
        address projectVotedFor;
        uint amount;
    }


    Details[] public NGODetails;
    ProjectDetails[] public projectDetails;
    MatchPool[] public matchPool;

    mapping(address => Voter) public voted;
    mapping(address => uint) public amtDonationArray;

    constructor(IERC20 _donationToken) {
        donationToken = _donationToken;
    }

    function registerDetails(string memory _name, address _ngoAddress) public {
        _ngoIds.increment();
        uint ngoIds = _ngoIds.current();

        NGODetails.push(Details(ngoIds, _name, _ngoAddress));
    }

    function howManyProjects(uint _numOfProjects) public pure {
        require(_numOfProjects > 1, "should be more than 2");
        // numOfProject = _numOfProjects;
    }

    // function registerProjects() public {
    
    // }

    function Projects(uint _projects, uint _ngoId, uint _pId, string memory _pName, address _pAddress) public {
        require(_pAddress != address(0), "Cannot have zero address");
        howManyProjects(_projects);
        numOfProject = _projects;
        for(uint i = 0; i < numOfProject; i++) {
            projectDetails.push(ProjectDetails(
                _pId, 
                _pName,
                _pAddress,
                0,
                0,
                NGODetails[_ngoId]
            ));
        }
    }

    function createPool(uint _poolId, uint _pId, address _poolCreator, uint _startTime, uint _endTime, uint _amount) public {
        startTime = _startTime;
        endTime = _endTime;

        payoutAuthority = _poolCreator;
        payoutAmount = _amount;
        
        matchPool.push(MatchPool(
            _poolId,
            _poolCreator,
            _startTime,
            _endTime,
            _amount,
            projectDetails[_pId]
        ));
    }

    function getNGO(uint _id) public view returns(uint, string memory, address) {
        return(NGODetails[_id].id, NGODetails[_id].name, NGODetails[_id].dAddress);
    }

    // function getProjectDetails(uint _pId, uint _ngoId) public view returns(uint , string memory, address, uint, Details[] memory) {
    //     Details storage d = projectDetails[_pId].details[];
    //     return(projectDetails[_pId].id, projectDetails[_pId].name, projectDetails[_pId].pAddress, projectDetails[_pId].balance, d);
    // }

    function startVotingInPool(uint _amount, uint _projectId) public {
        require(block.timestamp > startTime && block.timestamp < endTime, "Donation Over");
        uint amt = _amount;
    
        projectDetails[_projectId].balance = amt;
        projectDetails[_projectId].voteCount++;

        address pAdd = projectDetails[_projectId].pAddress;
        
        amtDonationArray[pAdd] = amt;
        IERC20(donationToken).transferFrom(msg.sender, projectDetails[_projectId].pAddress, _amount);
    }

    // function provideMoney() public {
    //     require(block.timestamp > endTime);
    //     uint pNumber = projectDetails.length;


    // }
}
