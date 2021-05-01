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
    uint256 public immutable START_TIME;

    constructor(IERC20 _tokenToMigrate, address _newToken, uint256 _START_TIME) public {
        tokenToMigrate = _tokenToMigrate;
        newToken = _newToken;
        START_TIME = _START_TIME;
    }

    function migrate(uint256 _amount) public {
        require(!migrationEnded, "Migrator: Migration ended");
        tokenToMigrate.safeTransferFrom(msg.sender, 0x000000000000000000000000000000000000dEaD, _amount);
        IMigrateableToken(tokenToMigrate).migrate(msg.sender, _amount);
    }

    function endMigration() public onlyOwner {
        migrationEnded = true;
    }

}