pragma solidity =0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";

contract Register {
    using Counters for Counters.Counter;
    Counters.Counter public ngoIds;
    Counters.Counter public _projectIds;


    struct NGODetails {
        uint Id;
        string name;
    }

    struct ProjectDetails {
        uint projectId;
        NGODetails ngoDetailsforProject;
        string projectDesc;
        uint projectStart;
        uint projectComplete;
    }

    mapping(uint => ProjectDetails) public projectDetails;

    mapping(uint => NGODetails) public ngoDetails;

    function registerNGO(string memory _name) public {
        ngoIds.increment();
        uint Id = ngoIds.current();

        ngoDetails[Id] = NGODetails (
            Id,
            _name
        );
    }

    function addProject(uint _ngoId, string memory _projectDesc, uint _projectStart, uint _projectEnd) public {
        _projectIds.increment();
        uint projectId = _projectIds.current();

        projectDetails[projectId] = ProjectDetails (
            projectId,
            ngoDetails[_ngoId],
            _projectDesc,
            _projectStart,
            _projectEnd
        );
    }
}