// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedArraySort {
    function sortArray(uint256[] calldata data) external pure returns (uint256[] memory _data) {
        uint256 dataLen = data.length;

        unchecked {
            _data = data;
            for (uint256 i = 0; i < dataLen; i++) {
                for (uint256 j = i+1; j < dataLen; j++) {
                    if(_data[i] > _data[j]){
                        uint256 temp = _data[i];
                        _data[i] = _data[j];
                        _data[j] = temp;
                    }
                }
            }
        }
    }
}