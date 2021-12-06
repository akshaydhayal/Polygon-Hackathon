// SPDX-License-Identifier: MIT
pragma solidity =0.8.0;

import "../MatchPoolData.sol";

contract Factory {
    MatchPoolData[] public matchPool;

    event matchPoolCreated(address _matchpoolData);

    function createMatchPool() public {

    }
}