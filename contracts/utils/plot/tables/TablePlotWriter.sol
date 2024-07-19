// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "thefactory/utils/math/Constants.sol";
import "thefactory/utils/primitives/Primitives.sol";


import "./TableBuilder.sol";
import "./TableConsoleWriter.sol";
import "./TableCSVWriter.sol";

import "thefactory/terminal/Terminal.sol";
import "solplot/src/Plot.sol";

abstract contract TablePlotWriter is Plot, Terminal {

    using TableBuilder for Row;
    using TableBuilder for Table;
    using TableConsoleWriter for Table;
    using TableCSVWriterLib for bytes32;
    using String for string;
    using UInt for uint256;

    Table private _plotTable;

    // function _tc() internal virtual returns(TestContext);

    function plotTable(
        bytes32 tableSlot,
        string memory csvPath,
        string memory svgPath,
        uint256 precision,
        // uint256 columns,
        uint256 imgWidth,
        uint256 imgHeight
    ) public {
        try vm.removeFile(svgPath) {} catch {}
        // _tc().terminal().createFile(svgPath);
        createFile(svgPath);
        _plotTable = tableSlot._asTable();
        Table storage table = _plotTable;
        plot(
            csvPath,
            svgPath,
            table._title(),
            precision,
            table._width(),
            imgWidth,
            imgHeight,
            true
        );
    }

}