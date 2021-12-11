// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";

contract Quadratic {
    uint amt;
    uint mPoolId;
    uint counter;

    IERC20 donationToken;

    struct NGO {
        string name;
        string someval;
    }

    struct Project {
        uint pId;
        string name;
        // uint pStartTime;        
        // uint PEndTime;        
        uint voterCount;
        uint allAmt; 
        Voter[] voter;
        mapping(address => uint) voterAddToAmtForProject;
    }

    struct MatchPool {
        uint id;
        uint startTime; 
        uint endTime;
        address creator; 
        uint amount;
        // mapping(address => Project) projectsInPool;    
    }

    struct Voter {
        address vote;
        uint amount;
    }

    // Project[] public proj;    
    mapping(address => NGO) ngo;
    mapping(uint => Project) idToProject;
    mapping(uint => address) idToProjectAddress;
    mapping(address => Project) p;
    mapping(address => NGO) projectToNGO;
    mapping(uint => MatchPool) matchPool;
    mapping(address => address) projectsInMatchPool;

    function sendAmountToProjects(uint id) public payable returns(uint) {
        uint c;
        uint total;
        uint amtToSend;
        uint plength = counter;
        for(uint i = 0; i < plength; i++) { 
            total += idToProject[i].allAmt;
            c = idToProject[i].voterCount;
            amtToSend = (idToProject[i].allAmt * matchPool[id].amount) / total;
            // SafeERC20.safeTransferFrom(donationToken, matchPool[id].creator, idToProjectAddress[i], amtToSend);            
            (bool sent, ) = address(idToProjectAddress[i]).call{ value: amtToSend }("");
            require(sent, "Failed to send Ether");
            }
            return amtToSend;
        }

    function sqrt(uint x) public pure returns(uint y) {
        uint z = (x + 1) / 2;
        y = x;
        while(z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }

    function voteForProject(uint _amt, address payable projAdd) public payable {
        uint count = 0;
        uint amnt = 0;
        Project storage pk = p[projAdd]; 
        // SafeERC20.safeTransferFrom(donationToken, msg.sender, projAdd, _amt);        
        (bool sent, ) = projAdd.call{value: _amt}("");
        require(sent, "Failed to send Ether"); 
        pk.voterAddToAmtForProject[msg.sender] = _amt;
        amnt += sqrt(_amt);
        pk.allAmt = (amnt) ** 2;
        Voter memory v = Voter(msg.sender, _amt);
        pk.voterCount = count;
        pk.voter.push(v);

        // return msg.value;
    }

    function getDonors(address padd) public view returns(uint) {
        Project storage pst = p[padd];
        return(pst.voterAddToAmtForProject[msg.sender]);
    } 
    
    function setMatchPool(uint sTime, uint eTime, address _creator, uint _amt) public {
        MatchPool storage mp = matchPool[mPoolId++];
        mp.startTime = sTime;
        mp.endTime = eTime;
        mp.creator = _creator;
        mp.amount = _amt;
    }

    // function getMatchPool(uint _id) public returns(uint, uint, uint, address, uint) {
    //     return(matchPool[_id].id, matchPool[_id].startTime, matchPool[_id].endTime, matchPool[_id].creator, matchPool[_id].amount);
    // }

    function setProject(
        address poolAddr, 
        address ngoA, 
        address pAddress, 
        string memory _name) public {
        require(pAddress != address(0), "address is zero address");
        Project storage pn = p[pAddress];
        pn.name = _name;
    
        Project storage pp = idToProject[counter];
        pp.name = _name;
    
        idToProjectAddress[counter] = pAddress;
        projectToNGO[pAddress] = ngo[ngoA];
        projectsInMatchPool[poolAddr] = pAddress;
        
        counter++; 
    }

    function projectsMatchPool(address _poolAddress) public view returns(string memory) { 
        address pAdd = projectsInMatchPool[_poolAddress];

        return(p[pAdd].name); 
    }

    function getProject(address pAdd) public view returns(string memory) {
        return(p[pAdd].name);
    }

    function getNGOOfProject(address _pAddr) public view returns(NGO memory) {
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