pragma solidity 0.5.16;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract MigrateableToken is ERC20, ERC20Detailed, Ownable {
    address public migrator;
    bool public migratorInitialized;

    constructor(
        string memory _name, 
        string memory _symbol
    ) public ERC20Detailed(_name, _symbol, 18) {}

    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    function setMigrator(address _migrator) public onlyOwner {
        require(!migratorInitialized, "MigrateableToken: Migrator already initialized");
        migrator = _migrator;
    }

    function migrate(address _to, uint256 _amount) public {
        require(msg.sender == migrator, "MigrateableToken: Caller not migrator");
        _mint(_to, _amount);
    }

}