/*
 * Copyright (C) 2014 The CyanogenMod Project
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

package org.cyanogenmod.hardware;

import android.os.SystemProperties;

/**
 * Support for displaying a different serial number in Settings -> About Phone
 * than ro.serialno, which may be different than the actual serial number
 * sticker on the hardware.
 */
public class SerialNumber {

    /**
     * Whether device requires an alternative serial number.
     *
     * @return boolean Supported devices must return always true
     */
    public static boolean isSupported() { return true; }

    /**
     * Returns the alternative serial number to be displayed.
     */
    public static String getSerialNumber() {
        return SystemProperties.get("ril.serialnumber");
    }

}
