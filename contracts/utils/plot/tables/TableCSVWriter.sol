// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "thefactory/utils/math/Constants.sol";
import "thefactory/utils/primitives/Primitives.sol";

import "./TableBuilder.sol";
import "./TableConsoleWriter.sol";

// import "forge-std/Test.sol";
import "thefactory/terminal/Terminal.sol";
import {Plot} from "solplot/src/Plot.sol";
// import "contracts/daosys/core/context/types/TestContext.sol";
import "thefactory/terminal/Terminal.sol";

library TableCSVWriterLib {

    function _slot(
        Table storage table
    ) internal pure returns(bytes32 slot) {
        assembly{slot := table.slot}
    }

    function _asTable(
        bytes32 slot
    ) internal pure returns(Table storage table) {
        assembly{table.slot := slot}
    }

}

abstract contract TableCSVWriter is Plot, Terminal {

    using TableBuilder for Row;
    using TableBuilder for Table;
    using TableConsoleWriter for Table;
    using TableCSVWriterLib for bytes32;
    using String for string;
    using UInt for uint256;

    Table csvTable;

    // function _tc() internal virtual returns(TestContext);

    function writeTable(
        // Table storage table
        bytes32 tableSlot,
        string memory path
    ) public {
        // Table storage table = tableSlot._asTable();
        csvTable = tableSlot._asTable();
        console.log("Writing table to CSV at ", path);
        csvTable._log();
        _writeRows(path);
    }

    function _writeRows(
        // Table storage table
        string memory path
    ) private {
        try vm.removeFile(path) {} catch {}
        // _tc().terminal().createFile(path);
        createFile(path);
        Table storage table = csvTable;
        // uint256 rowLength = table.rows.length;
        // for(uint256 rowCursor = 0; rowCursor < rowLength; rowCursor++) {
        //     for(uint256 cursor = 0; cursor < rowLength; cursor++) {
        //         writeRowToCSV(path, table.rows[cursor].columns);
        //     }
        // }
        // uint256 colWidth = table._colWidth();
        uint256 rowLength = table.rows.length;
        for(uint256 rowCursor = 0; rowCursor < rowLength; rowCursor++) {
            // string memory line = " | ";
            // Row storage currentRow = table.rows[rowCursor];
            // uint256 colLength = currentRow.columns.length;
            // for(uint256 colCursor = 0; colCursor < colLength; colCursor++) {
            //     // line = string.concat(
            //     //     line,
            //     //     currentRow.columns[colCursor]._padLeft(" ", colWidth),
            //     //     " | "
            //     // );
            // }
            // console.log(line);
            // line = " | ";
            writeRowToCSV(path, table._row(rowCursor)._columns());
        }
    }

}