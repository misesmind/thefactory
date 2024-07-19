// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "thefactory/utils/primitives/Primitives.sol";

// Yes this could be done with a multi-dimensional array, but fuck figuring that out right now. I'm coding a tabular data writer in Solidity FFS.
struct Row {
    string[] columns;
}

struct Table {
    uint256 columnWidth;
    string title;
    Row[] rows;
}

/**
 * @title TableBuilder - Store data in contract state for use with SolPlot.
 * @dev Builds a table of string data for writing using SolPlot.
 * @dev Stores columss as string[] for simplified writing to CSV for plotting.
 * @dev Storing as string[] also simplifies using long values.
 */
// TODO Should enforce column width by checking width of last row when pushing a new row.
library TableBuilder {

    using String for string;
    using TableBuilder for Row;
    using TableBuilder for Table;

    /* ----------------------------- Initialization ----------------------------- */

    function _init(
        Table storage table
    ) internal returns(Table storage) {
        table._addRow();
        return table;
    }

    function _initColWidth(
        Table storage table
    ) internal returns(Table storage) {
        // table._addRow();
        for(uint256 rowCur = 0; rowCur < table.rows.length; rowCur++) {
            for(uint256 colCur = 0; colCur < table.rows[rowCur].columns.length; colCur++) {
                if(table.columnWidth < bytes(table.rows[rowCur].columns[colCur]).length) {
                    table.columnWidth = bytes(table.rows[rowCur].columns[colCur]).length;
                }
            }
        }
        return table;
    }

    /* ------------------------- Data Integrity Ops ------------------------- */

    function _setColWidth(
        Table storage table,
        uint256 valueLength
    ) internal returns(Table storage) {
        if(table.columnWidth < valueLength) {
            table.columnWidth = valueLength;
        }
        return table;
    }

    function _setColWidth(
        Table storage table,
        string memory value
    ) internal returns(Table storage) {
        return table._setColWidth(bytes(value).length);
    }

    /* -------------------------- Whole Table Props ------------------------- */

    function _title(
        Table storage table
    ) internal view returns(string storage) {
        return table.title;
    }

    function _setTitle(
        Table storage table,
        string memory title
    ) internal returns(Table storage) {
        table.title = title;
        return table;
    }

    function _heighth(
        Table storage table
    ) internal view returns(uint256) {
        return table._rows().length;
    }

    function _width(
        Table storage table
    ) internal view returns(uint256) {
        return table._headers()._columns().length;
    }

    function _colWidth(
        Table storage table
    ) internal view returns(uint256) {
        return table.columnWidth;
    }

    /* -------------------------------- Rows -------------------------------- */

    function _row(
        Table storage table,
        uint256 index
    ) internal view returns(Row storage) {
        return table.rows[index];
    }

    function _rows(
        Table storage table
    ) internal view returns(Row[] storage) {
        return table.rows;
    }
    
    function _lastRow(
        Table storage table
    ) internal view returns(Row storage) {
        // return table.rows[table.rows.length - 1];
        return table.rows[table.rows.length - 1];
    }

    function _addRow(
        Table storage table
    ) internal returns(Row storage) {
        // Just push an empty ROW.
        // Easier then extending the length.
        // Need to confirm that compiler DOES NOT include needless write of null data.
        table.rows.push();
        // return table.rows[table.rows.length - 1];
        return table._lastRow();
    }

    /* ------------------------------- Columns ------------------------------ */

    function _columns(
        Row storage row
    ) internal view returns(string[] storage) {
        return row.columns;
    }

    /**
     * @dev Pushes a value as a column on a Row.
     * @dev Useful for when you need to add values without having all the values.
     */
    function _addColumn(
        Row storage row,
        string memory value
    ) internal returns(Row storage) {
        // table.rows.push(Row({columns: columns}));
        row.columns.push(value);
        return row;
    }

    /* ------------------------------- Headers ------------------------------ */

    /*
    Headers as simply Row 0.
    Distinct function provided to simplify interaction with Row 0.
    Also used to set Table Width for data consistency checks.
     */

    function _headers(
        Table storage table
    ) internal view returns(Row storage) {
        return table._row(0);
    }

    function _addHeader(
        Table storage table,
        string memory header
    ) internal returns(Table storage) {
        // return row._addColumn(header);
        table._setColWidth(header)._headers()._addColumn(header);
        return table;
    }

    /* ---------------------------- REFACTORED ABOVE ---------------------------- */

    /**
     * @dev Pushes an array of strings as a row on the table.
     * @dev Can be used to set the legend if called first.
     */
    function _addRow(
        Table storage table,
        string[] memory columns
    ) internal returns(Table storage) {
        table.rows.push(Row({columns: columns}));
        return table;
    }

    function _addColumn(
        Table storage table,
        string memory value
    ) internal returns(Table storage) {
        // table.rows.push(Row({columns: columns}));
        // Row storage lastRow = table.rows[table.rows.length - 1];
        // return lastRow._addColumn(value);
        // uint256 colWidth = bytes(value).length;
        // if(table.columnWidth < colWidth) {
        //     table.columnWidth = colWidth;
        // }
        table._lastRow()._addColumn(value);
        return table;
    }

    // function _addHeader(
    //     Row storage row,
    //     string memory header
    // ) internal returns(Row storage) {
    //     return row._addColumn(header);
    // }

    function _addHeader(
        Row storage row,
        string memory header
    ) internal returns(Row storage) {
        return row._addColumn(header);
    }

    // Used for Console writer.
    // string constant FNL = " \n  ";

    // function _init(
    //     Table storage table,
    //     string memory title,
    //     string[] memory headers
    // ) internal returns(Table storage) {
    //     return table._setTitle(title)._addHeaders(headers);
    // }

    // function _init(
    //     Table storage table,
    //     string memory title
    // ) internal returns(Row storage) {
    //     return table._setTitle(title);
    // }

    // function _setTitle(
    //     Table storage table,
    //     string memory title
    // ) internal returns(Row storage) {
    //     table.title = title;
    //     return table._addRow();
    // }

    /**
     * @dev Set the "lengend" as the first row.
     * @dev Could benefit from tracking and enforcing the num of columns.
     * @dev Just overwrites
     */
    function _addHeaders(
        Table storage table,
        string[] memory headers
    ) internal returns(Table storage) {
        if(table.rows.length < 1) {
            // console.log("Row length less then 1 when setting legend");
            table.rows.push(Row({columns: headers}));
        }
        table.rows[0] = Row({columns: headers});
        return table;
    }

    /**
     * @dev Simplifies extending the num of rows for a table as needed when you don't have the values yet.
     * @param table The upon which to push an empty row.
     * @return The Row which was just pushed into `table`.
e    */
    function _addRow(
        Table storage table,
        bool setWidth
    ) internal returns(Table storage) {
        // Just push an empty ROW.
        // Easier then extending the length.
        // Need to confirm that compiler DOES NOT include needless write of null data.
        setWidth;
        table.rows.push();
        // return table.rows[table.rows.length - 1];
        return table;
    }

    // /**
    //  * @dev Pushes an array of strings as a row on the table.
    //  * @dev Can be used to set the legend if called first.
    //  */
    // function _addRow(
    //     Table storage table,
    //     string[] memory columns,
    //     bool setWidth
    // ) internal returns(Table storage) {
    //     // table.columnWidth = table.columnWidth < bytes()
    //     // table.rows.push(Row({columns: columns}));
    //     // columnWidth
    //     uint256 colLen = columns.length;
    //     // Row storage newRow = table._addRow();
    //     for(uint256 cursor = 0; cursor < colLen; cursor++) {
    //         uint256 colWidth = bytes(columns[cursor]).length;
    //         if(table.columnWidth < colWidth) {
    //             table.columnWidth = colWidth;
    //         }
    //         // newRow._addColumn();
    //     }
    //     // return table;
    //     return table._addRow(columns);
    // }

}