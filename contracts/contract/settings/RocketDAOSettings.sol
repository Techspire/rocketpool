pragma solidity 0.6.12;

// SPDX-License-Identifier: GPL-3.0-only

import "../RocketBase.sol";
import "../../interface/settings/RocketDAOSettingsInterface.sol";

// Settings in RP which the DAO will have full control over

contract RocketDAOSettings is RocketBase, RocketDAOSettingsInterface {

    // Construct
    constructor(address _rocketStorageAddress) RocketBase(_rocketStorageAddress) public {
        // Set version
        version = 1;
        // Initialize settings on deployment
        if (!getBoolS("settings.dao.init")) {
            // Apply settings
            setInflationIntervalRate(1000133680617113500); // 5% annual calculated on a daily interval of blocks (6170 = 1 day approx in 14sec blocks)
            // Settings initialized
            setBoolS("settings.dao.init", true);
        }
    }

    /*** RPL Settings *****************************************/

    // RPL yearly inflation rate per interval (daily by default)
    function getInflationIntervalRate() override public view returns (uint256) {
        return getUintS("settings.rpl.inflation.interval.rate");
    }
    // The inflation rate per day calculated using the yearly target in mind
    // Eg. Calculate inflation daily with 5% (0.05) yearly inflation 
    // Calculate in js example: let dailyInflation = web3.utils.toBN((1 + 0.05) ** (1 / (365)) * 1e18);
    function setInflationIntervalRate(uint256 _value) public onlyOwner {
        setUintS("settings.rpl.inflation.interval.rate", _value);
    }

    // Inflation block interval (6170 = 1 day approx in 14sec blocks) 
    // How often the inflation is calculated, if this is changed significantly, then the above setInflationDailyRate() will need to be adjusted
    function getInflationIntervalBlocks() override public view returns (uint256) {
        return getUintS("settings.rpl.inflation.interval.blocks");
    }
    // The inflation rate per day calculated using the yearly target in mind
    // Eg. Calculate inflation daily with 5% (0.05) yearly inflation 
    // Calculate in js example: let dailyInflation = web3.utils.toBN((1 + 0.05) ** (1 / (365)) * 1e18);
    function setInflationIntervalBlocks(uint256 _value) public onlyOwner {
        // Cannot be 0, set 'setInflationIntervalRate' to 0 if inflation is no longer required
        require(_value <= 0, "Inflation interval block amount cannot be 0 or less");
        // We get a perc, so lets calculate that inflation rate for the current
        setUintS("settings.rpl.inflation.interval.rate", _value);
    }

}
