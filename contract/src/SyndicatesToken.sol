// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.28;

import "./Tkn.sol";

contract SyndicatesToken is Tkn {
    address public admin;
    mapping(address => bool) public authorizedMinters;
    
    event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
    event MinterAuthorized(address indexed minter, bool authorized);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier onlyAuthorizedMinter() {
        require(authorizedMinters[msg.sender] || msg.sender == admin, "Not authorized to mint");
        _;
    }

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 totalSupply,
        address _admin
    ) Tkn(name, symbol, decimals, totalSupply) {
        admin = _admin;
        authorizedMinters[_admin] = true;
    }

    function mint(address to, uint256 amount) external override onlyAuthorizedMinter {
        _mint(to, amount);
    }

    function transferAdmin(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "New admin cannot be zero address");
        address previousAdmin = admin;
        admin = newAdmin;
        authorizedMinters[newAdmin] = true;
        emit AdminTransferred(previousAdmin, newAdmin);
    }

    function setMinterAuthorization(address minter, bool authorized) external onlyAdmin {
        authorizedMinters[minter] = authorized;
        emit MinterAuthorized(minter, authorized);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function burnFrom(address from, uint256 amount) external {
        uint256 currentAllowance = allowance(from, msg.sender);
        require(currentAllowance >= amount, "Burn amount exceeds allowance");
        _approve(from, msg.sender, currentAllowance - amount);
        _burn(from, amount);
    }
} 