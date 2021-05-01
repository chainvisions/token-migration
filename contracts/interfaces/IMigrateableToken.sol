pragma solidity 0.5.16;

interface IMigrateableToken {
    function migrate(address _to, uint256 _amount) external;
    function migrator() external view returns (address);
}