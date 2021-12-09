// SPDX-License-Identifier: MIT
pragma solidity =0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin-contracts/contracts/math/SafeMath.sol";

 

contract Quadratic {

    uint mPoolId;

 
    struct NGO {
        string name;
        string someval;
    }

 

    struct Project {
        string name;
        // uint pStartTime;
        // uint PEndTime;
        mapping(address => uint) voterAddToAmtForProject;
    }

    struct MatchPool {
        uint id;
        uint startTime;
        uint endTime;
        uint creator;
        uint amount;
        mapping(address => Project) projectsInPool;
    }

    mapping(address => NGO) ngo;
    mapping(address => Project) p;
    mapping(address => NGO) projectToNGO;
    mapping(uint => MatchPool) matchPool;
    mapping(address => Project) projectsInMatchPool;

 
    function setMatchPool(uint sTime, uint eTime, uint _creator, uint _amt) public {
        MatchPool storage mp = matchPool[mPoolId++];

        mp.startTime = sTime;
        mp.endTime = eTime;
        mp.creator = _creator;
        mp.amount = _amt;
    }

 

    // function getMatchPool(uint _id) public returns(uint, uint, uint, address, uint) {

    //     return(matchPool[_id].id, matchPool[_id].startTime, matchPool[_id].endTime, matchPool[_id].creator, matchPool[_id].amount);

    // }

 

    function setProject(address poolAddr, address ngoA, address pAddress, string memory _name) public {

        Project storage pn = p[pAddress];

        pn.name = _name;

 
        projectToNGO[pAddress] = ngo[ngoA];
        projectsInMatchPool[poolAddr] = p[pAddress];

    }

 
    function getProject(address pAdd, address voter) public returns(string memory) {
        return(p[pAdd].name);
    }


    function getNGOOfProject(address _pAddr) public returns(NGO memory) {
        return(projectToNGO[_pAddr]);
    }

 
    function setNgo(address add, string memory n, string memory some) public {
        NGO memory nd = NGO(n, some);
        ngo[add] = nd;
    }

 
    function getNGO(address a) public view returns(string memory, string memory) {
        return(ngo[a].name, ngo[a].someval);
    }

}