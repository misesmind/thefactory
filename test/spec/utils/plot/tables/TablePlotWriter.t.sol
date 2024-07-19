// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

// solhint-disable no-global-import
// solhint-disable state-visibility
// solhint-disable func-name-mixedcase
// import "contracts/test/foundry/extensions/ExtendedTest.sol";
// import "contracts/daosys/core/test/DAOSYSTest.sol";
import "thefactory/test/BetterTest.sol";

import "thefactory/utils/math/Constants.sol";
import "thefactory/utils/primitives/Primitives.sol";
import "thefactory/utils/plot/tables/TableBuilder.sol";
import "thefactory/utils/plot/tables/TableConsoleWriter.sol";
import "thefactory/utils/plot/tables/TableCSVWriter.sol";
import "thefactory/utils/plot/tables/TablePlotWriter.sol";

/**
 * @dev Test scenario 
 */
contract TablePlotWriterTest is BetterTest, TableCSVWriter, TablePlotWriter {

    using TableBuilder for Row;
    using TableBuilder for Table;
    using TableConsoleWriter for Row;
    using TableConsoleWriter for Table;
    using TableCSVWriterLib for bytes32;
    using TableCSVWriterLib for Table;
    using UInt for uint256;

    string CSV_PATH = string.concat("test/spec/utils/plot/tables/results/TablePlotWriter/test", CSV);
    string SVG_PATH = string.concat("test/spec/utils/plot/tables/results/TablePlotWriter.t.sol/test", SVG);

    Table testTable;

    string constant testTitle = "Greetings";
    uint256 seriesLen = 10;
    uint256 maxTick = seriesLen;
    uint256 numGreeters = 3;
    uint256 helloRate = 1;
    mapping(uint256 tick => mapping(uint256 greeter => uint256 numGreetings)) greetingsPerGreeter;

    // function _tc() internal virtual override(TableCSVWriter, TablePlotWriter) returns(TestContext) {
    //     return tc();
    // }

    function _initGreeters()
    internal {
        for(uint256 tick = 0; tick <= maxTick; tick++) {
            for(uint256 greeterCursor = 0; greeterCursor < numGreeters; greeterCursor++) {
                greetingsPerGreeter[tick][greeterCursor] = greeterCursor + helloRate;
            }
        }
    }

    function _storeHeaders()
    internal {
        testTable._addHeader(PLOT_CORRELATOR);
        for(uint256 greeterCursor = 0; greeterCursor < numGreeters; greeterCursor++) {
            testTable._addHeader(string.concat("Greeter ", greeterCursor._toString()));
        }
    }

    function _storeGreeters()
    internal {
        for(uint256 tick = 0; tick <= maxTick; tick++) {
            testTable._addRow()._addColumn(tick._toString());
            for(uint256 greeterCursor = 0; greeterCursor < numGreeters; greeterCursor++) {
                testTable._lastRow()._addColumn(greetingsPerGreeter[tick][greeterCursor]._toString());
            }
        }
    }

    function setUp()
    public {
        testTable._init();
    }

    function test_title()
    public {
        testTable._setTitle(testTitle);
        testTable._logTitle();
    }

    function test_headers()
    public {
        _initGreeters();
        testTable._setTitle(testTitle);
        _storeHeaders();
        testTable._logHeaders();
    }

    function test_log()
    public {
        _initGreeters();
        testTable._setTitle(testTitle);
        _storeHeaders();
        _storeGreeters();
        testTable._log();
    }

    function test_writeTable()
    public {
        _initGreeters();
        testTable._setTitle(testTitle);
        _storeHeaders();
        _storeGreeters();
        writeTable(testTable._slot(), CSV_PATH);
    }

    function test_plotTable()
    public {
        _initGreeters();
        testTable._setTitle(testTitle);
        _storeHeaders();
        _storeGreeters();
        // testTable._log();
        // testTable._log();
        writeTable(testTable._slot(), CSV_PATH);
        plotTable(
            testTable._slot(),
            CSV_PATH,
            SVG_PATH,
            1,
            900,
            600
        );
    }
    
}