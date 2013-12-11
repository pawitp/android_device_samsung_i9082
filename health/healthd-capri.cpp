/*
 * Copyright (C) 2013 The Android Open Source Project
 * Copyright (C) 2013 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <healthd.h>

void
healthd_board_init(struct healthd_config *config)
{
    // battery needs to be used instead of bcm59056_charger
    config->batteryStatusPath      = "/sys/class/power_supply/battery/status";
    config->batteryHealthPath      = "/sys/class/power_supply/battery/health";
    config->batteryPresentPath     = "/sys/class/power_supply/battery/present";
    config->batteryCapacityPath    = "/sys/class/power_supply/battery/capacity";
    config->batteryVoltagePath     = "/sys/class/power_supply/battery/voltage_now";
    config->batteryTemperaturePath = "/sys/class/power_supply/battery/temp";
    config->batteryTechnologyPath  = "/sys/class/power_supply/battery/technology";
}

int
healthd_board_battery_update(struct android::BatteryProperties *props)
{
    // don't log to kernel
    return 1;
}
