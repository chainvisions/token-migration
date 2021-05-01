pragma solidity 0.5.16;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "./interfaces/IMigrateableToken.sol";

contract Migrator is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public tokenToMigrate;
    address public newToken;
    bool public migrationEnded;
    uint256 public START_TIME;

    constructor(IERC20 _tokenToMigrate, address _newToken, uint256 _START_TIME) public {
        tokenToMigrate = _tokenToMigrate;
        newToken = _newToken;
        START_TIME = _START_TIME;
    }

    function migrate() public {
        require(block.timestamp >= START_TIME);
        require(!migrationEnded, "Migrator: Migration ended");
        uint256 toMigrate = tokenToMigrate.balanceOf(msg.sender);
        tokenToMigrate.safeTransferFrom(msg.sender, 0x000000000000000000000000000000000000dEaD, toMigrate);
        IMigrateableToken(newToken).migrate(msg.sender, toMigrate);
    }

    function endMigration() public onlyOwner {
        migrationEnded = true;
    }

}