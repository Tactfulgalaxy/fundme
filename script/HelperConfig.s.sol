// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
// Deploy mocks when we are on a local anvil chain
// Keep track of contract address across different chain
contract HelperConfig is Script{
    // If we are on a local anvil, we deploy mocks
    //Otherwise, we grab the existing address from the live network
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    struct NetworkConfig{
        address pricefeed;
    }
    constructor(){
        if (block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else if (block.chainid == 1){
            activeNetworkConfig = getMainnetEthConfig();
        }
        else{
            activeNetworkConfig = getOrCreateEthAnvilConfig();
        }
        
    }
    function getSepoliaEthConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory SepoliaConfig = NetworkConfig({pricefeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 });
        return SepoliaConfig;
    }
    function getMainnetEthConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory ethConfig = NetworkConfig({pricefeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 });
        return ethConfig;
    }
    function getOrCreateEthAnvilConfig() public  returns(NetworkConfig memory){
        if (activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }
        // price feed address
        //1 Deploy the mocks
        //2 Return the mock address
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS , INITIAL_PRICE);
        vm.stopBroadcast();

       // NetworkConfig memory anvilconfig = NetworkConfig({PriceFeed: address{(address(mockPriceFeed))}});
       NetworkConfig memory anvilconfig = NetworkConfig({pricefeed: address(mockPriceFeed)});

        return anvilconfig;
    }
}