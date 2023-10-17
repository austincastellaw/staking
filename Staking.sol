// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Staking {
    address public owner;

    struct Position {
        uint positionId;
        address walletAddress;
        uint createdDate;
        uint unlockDate;
        uint percentInterest;
        uint weiStaked;
        uint weiInterest;
        bool open;
    }
    Position position;

    uint public currentPositionId;
    mapping(uint => Position) public positions;
    mapping(address => uint[]) positionIdsByAddress;
    mapping(uint => uint) public tiers;
    uint[] public lockPeriods;

    constructor() payable {
        owner = msg.sender;
        currentPositionId = 0;

        tiers[0] = 700;
        tiers[30] = 800;
        tiers[60] = 900;
        tiers[90] = 1200;

        lockPeriods.push(0);
        lockPeriods.push(30);
        lockPeriods.push(60);
        lockPeriods.push(90);
    }

    function stakeEther(uint numDays) external payable {
        require(tiers[numDays] > 0, "Mapping not found");

        positions[currentPositionId] = Position(
            currentPositionId,
            msg.sender,
            block.timestamp,
            block.timestamp + (numDays * 1 days),
            tiers[numDays],
            msg.value,
            calculateInterest(tiers[numDays], msg.value),
            true
        );

        positionIdsByAddress[msg.sender].push(currentPositionId);
        currentPositionId += 1;
    }

    function calculateInterest(
        uint basispoints,
        uint weiAmount
    ) private pure returns (uint) {
        return (basispoints * weiAmount) / 10000;
    }

    function getLockPeriods() external view returns (uint[] memory) {
        return lockPeriods;
    }

    function getInterestRate(uint numDays) external view returns (uint) {
        return tiers[numDays];
    }

    function getPositionById(
        uint positionId
    ) external view returns (Position memory) {
        return positions[positionId];
    }

    function getPositionIdsForAddress(
        address walletAddress
    ) external view returns (uint[] memory) {
        return positionIdsByAddress[walletAddress];
    }

    function closePosition(uint positionId) external {
        require(
            positions[positionId].walletAddress == msg.sender,
            "only position creator can modify postions"
        );
        require(positions[positionId].open == true, "position is closed");

        positions[positionId].open = false;

        uint amount = positions[positionId].weiStaked +
            positions[positionId].weiInterest;
        payable(msg.sender).transfer(amount);
    }
}
