// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "thefactory/utils/primitives/Primitives.sol";

import "./TableBuilder.sol";

import "forge-std/console.sol";

library TableConsoleWriter {

    using TableBuilder for Row;
    using TableBuilder for Table;
    using TableConsoleWriter for Table;
    using String for string;
    using UInt for uint256;

    function _log(
        Table storage table
    ) internal view {
        console.log(
            string.concat(
                "Table Title: ",
                table._title(),
                " | ",
                "Num Rows: ",
                table._heighth()._toString(),
                " | ",
                "Num columns: ",
                table._width()._toString(),
                " | ",
                "Column width: ",
                table._colWidth()._toString()
            )
        );
        string memory divider;
        divider = divider._padLeft("-", ((table._width() * table._colWidth()) + table._width()) + 1);
        console.log(divider);
        table._logHeaders();
        // console.log(divider);
        table._logRowsEx();
    }

    function _logTitle(
        Table storage table
    ) internal view {
        console.log(
            string.concat(
                "Table Title: ",
                table._title()
            )
        );
    }

    // TODO Simplify with _logRow.

    function _logHeaders(
        Table storage table
    ) internal view {
        uint256 colWidth = table._colWidth();
        string memory line = " | ";
        Row storage currentRow = table._headers();
        uint256 colLength = currentRow.columns.length;
        for(uint256 colCursor = 0; colCursor < colLength; colCursor++) {
            // line = string.concat(line, currentRow.columns[colCursor], " | ");
            line = string.concat(line, currentRow.columns[colCursor]._padLeft(" ", colWidth), " | ");
        }
        console.log(line);
    }

    function _logRows(
        Table storage table
    ) internal view {
        uint256 colWidth = table._colWidth();
        uint256 rowLength = table.rows.length;
        for(uint256 rowCursor = 0; rowCursor < rowLength; rowCursor++) {
            string memory line = " | ";
            Row storage currentRow = table.rows[rowCursor];
            uint256 colLength = currentRow.columns.length;
            for(uint256 colCursor = 0; colCursor < colLength; colCursor++) {
                line = string.concat(
                    line,
                    currentRow.columns[colCursor]._padLeft(" ", colWidth),
                    " | "
                );
            }
            console.log(line);
            // line = " | ";
        }
    }

    function _logRowsEx(
        Table storage table
    ) internal view {
        uint256 colWidth = table._colWidth();
        uint256 rowLength = table.rows.length;
        for(uint256 rowCursor = 1; rowCursor < rowLength; rowCursor++) {
            string memory line = " | ";
            Row storage currentRow = table.rows[rowCursor];
            uint256 colLength = currentRow.columns.length;
            for(uint256 colCursor = 0; colCursor < colLength; colCursor++) {
                line = string.concat(
                    line,
                    currentRow.columns[colCursor]._padLeft(" ", colWidth),
                    " | "
                );
            }
            console.log(line);
            // line = " | ";
        }
    }


}