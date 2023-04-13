//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./IERC20.sol";

contract TryCatchExample {
    function aFunction() public pure {
        //require(false, "TryCatchExample");
        assert(false);
    }
}

contract ErrorHandling {
    event ErrorLogging(string reason);
    event ErrorLogCode(uint code);
    event ErrorLogBytes(bytes lowLevelData);

    function catchTheError() public {
        TryCatchExample TryCatch = new TryCatchExample();
        try TryCatch.aFunction() {
            //TODO:
        } catch Error(string memory reason) {
            emit ErrorLogging(reason);
        } catch Panic(uint errorCode) {
            emit ErrorLogCode(errorCode);
        } catch (bytes memory lowLevelData) {
            emit ErrorLogBytes(lowLevelData);
        }
    }
}
