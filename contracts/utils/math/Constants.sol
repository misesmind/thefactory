// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

uint256 constant MAX_UINT256 = type(uint256).max;
int256 constant MAX_INT256 = type(int256).max;

uint32 constant PPM_RESOLUTION = 1_000_000;

uint256 constant WAD = 1e18; // The scalar of ETH and most ERC20s.

// uint256 constant ONE_WAD = 1 * 10**18;
uint256 constant ONE_WAD = 10e18;
uint256 constant TEN_WAD = ONE_WAD * 10;
uint256 constant HUNDRED_WAD = ONE_WAD * 10;
uint256 constant ONEK_WAD = HUNDRED_WAD * 10;
uint256 constant TENK_WAD = ONEK_WAD * 10;
uint256 constant HUNDREDK_WAD = TENK_WAD * 10;
uint256 constant ONEM_WAD = HUNDREDK_WAD * 10;
uint256 constant TENM_WAD = ONEM_WAD * 10;
uint256 constant HUNDREDM_WAD = TENM_WAD * 10;

string constant CSV = ".csv";
string constant SVG = ".svg";
string constant PLOT_CORRELATOR = "x-axis";

string constant SEP = "********************************************************************************";
string constant DIV = "--------------------------------------------------------------------------------";