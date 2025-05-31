// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.28;

import "forge-std/Script.sol";
import {SyndicatesToken} from "src/SyndicatesToken.sol";
import {Tkn} from "src/Tkn.sol";
import {Router} from "src/Router.sol";
import {Pair} from "src/Pair.sol";
import {WETH} from "@solady/contracts/tokens/WETH.sol";

contract DeploySyndicates is Script {
    function run() public {
        uint256 signer = vm.envOr("PRIVATE_KEY", uint256(0x0));
        if (signer == 0) {
            // Fallback for command line private key
            signer = 0xbe9984e9daed48cbf21cbb6c194b7375d8a2b9f3395a1f068d9f9c5fd0db35be;
        }
        
        address pubKey = vm.addr(signer);
        console2.log("Deployer: ", pubKey);
        console2.log("Balance: ", pubKey.balance);

        vm.startBroadcast(signer);

        // Deploy WETH for testing
        WETH weth = new WETH();

        // Deploy Syndicates Membership Token
        SyndicatesToken membershipToken = new SyndicatesToken(
            "Syndicates Membership",
            "SYND",
            18,
            1000000, // 1M initial supply
            pubKey   // Admin
        );

        // Deploy some test tokens for trading
        Tkn pepe = new Tkn("Pepe", "PEPE", 18, 1000000);
        Tkn doge = new Tkn("Doge", "DOGE", 18, 1000000);

        // Deploy Router for DEX functionality
        Router router = new Router(address(weth));

        // Deploy trading pairs
        Pair pepePair = new Pair(address(weth), address(pepe));
        Pair dogePair = new Pair(address(weth), address(doge));

        console2.log("=== SYNDICATES DEPLOYMENT COMPLETE ===");
        console2.log("Membership Token (SYND): ", address(membershipToken));
        console2.log("WETH: ", address(weth));
        console2.log("Router: ", address(router));
        console2.log("PEPE/WETH Pair: ", address(pepePair));
        console2.log("DOGE/WETH Pair: ", address(dogePair));
        console2.log("PEPE: ", address(pepe));
        console2.log("DOGE: ", address(doge));

        vm.stopBroadcast();
    }
} 