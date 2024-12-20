// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundME is Test {
    FundMe fundme;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;

    function setUp() external {
        fundme = new FundMe();
    }

    function testMinimumDollarIs5() public {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundme.i_owner(), address(this));
    }
    function testPriceFeedVersionIsAccurate() public{
        uint256 version = fundme.getVersion();
        assertEq(version , 4);
    }
    function testFundFailswithoutEnoughETH() public {
        vm.expectRevert(); // the next line should revert
        fundMe.fund(); // sends 0 value
    }
    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); //The next transcation will be sent by USER
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded , SEND_VALUE);
    }
}
