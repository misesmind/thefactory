// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Base.sol";

contract Terminal is CommonBase {

    function createFile(
        string memory path
    ) public {
        mkDir(dirName(path));
        touch(path);
    }

    function dirName(
        string memory path
    ) public returns(string memory) {
        string[] memory ffi = new string[](2);
        ffi[0] = "dirname";
        ffi[1] = path;
        return string(vm.ffi(ffi));
    }

    function mkDir(
        string memory path
    ) public {
        string[] memory ffi = new string[](3);
        ffi[0] = "mkdir";
        ffi[1] = "-p";
        ffi[2] = path;
        vm.ffi(ffi);
    }

    function touch(
        string memory path
    ) public {
        string[] memory ffi = new string[](2);
        ffi[0] = "touch";
        ffi[1] = path;
        vm.ffi(ffi);
    }

}