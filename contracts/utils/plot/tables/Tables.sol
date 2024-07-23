// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TableBuilder.sol";
import "./TableConsoleWriter.sol";
import "./TableCSVWriter.sol";
import "./TablePlotWriter.sol";

    using TableBuilder for Row;
    using TableBuilder for Table;
    using TableConsoleWriter for Row;
    using TableConsoleWriter for Table;
    using TableCSVWriterLib for bytes32;
    using TableCSVWriterLib for Table;