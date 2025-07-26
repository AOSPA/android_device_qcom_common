/*
 * SPDX-FileCopyrightText: 2025 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

package org.lineageos.qtitelephonyservice.compat

import android.Manifest
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.IBinder
import android.os.PersistableBundle
import android.telephony.CarrierConfigManager
import android.telephony.SubscriptionManager
import android.util.Log
import androidx.annotation.RequiresPermission
import com.android.internal.telephony.util.ArrayUtils
import com.qti.extphone.Client
import com.qti.extphone.ExtPhoneCallbackListener
import com.qti.extphone.ExtTelephonyManager
import com.qti.extphone.NrConfig
import com.qti.extphone.ServiceCallback
import com.qti.extphone.Status
import com.qti.extphone.Token

class QtiTelephonyServiceCompat : Service() {
    private var client: Client? = null
    private var serviceConnected = false

    private val carrierConfigManager by lazy { getSystemService(CarrierConfigManager::class.java) }
    private val extTelephonyManager by lazy { ExtTelephonyManager.getInstance(applicationContext) }

    private val extPhoneCallbackListener = object : ExtPhoneCallbackListener() {
        override fun onNrConfigStatus(
            slotId: Int,
            token: Token?,
            status: Status?,
            nrConfig: NrConfig?,
        ) {
            val configStr = when (nrConfig?.get()) {
                NrConfig.NR_CONFIG_COMBINED_SA_NSA -> "COMBINED_SA_NSA"
                NrConfig.NR_CONFIG_NSA -> "NSA"
                NrConfig.NR_CONFIG_SA -> "SA"
                else -> "INVALID"
            }
            Log.d(LOG_TAG, "onNrConfigStatus: slotId = $slotId, nrConfig = $configStr")
        }

        override fun onSetNrConfig(slotId: Int, token: Token?, status: Status?) {
            client?.let {
                extTelephonyManager.queryNrConfig(slotId, it)
            }
        }
    }

    private val serviceCallback = object : ServiceCallback {
        override fun onConnected() {
            Log.d(LOG_TAG, "Connected to ExtTelephonyService")
            serviceConnected = true
            client = extTelephonyManager.registerCallbackWithEvents(
                applicationContext.packageName,
                extPhoneCallbackListener,
                intArrayOf(),
            )
        }

        override fun onDisconnected() {
            Log.d(LOG_TAG, "Disconnected from ExtTelephonyService")
            if (serviceConnected) {
                extTelephonyManager.unregisterCallback(extPhoneCallbackListener)
                serviceConnected = false
                client = null
            }
        }
    }

    private val carrierConfigReceiver = object : BroadcastReceiver() {
        @RequiresPermission(Manifest.permission.READ_PHONE_STATE)
        override fun onReceive(context: Context, intent: Intent) {
            val slotId = intent.getIntExtra(SubscriptionManager.EXTRA_SLOT_INDEX, -1)
            val subId = intent.getIntExtra(SubscriptionManager.EXTRA_SUBSCRIPTION_INDEX, -1)

            if (slotId != -1 && subId != -1) {
                val bundle =
                    carrierConfigManager.getConfigForSubId(
                        subId,
                        CarrierConfigManager.KEY_CARRIER_NR_AVAILABILITIES_INT_ARRAY
                    )
                updateCarrierNrConfig(bundle, slotId)
            }
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()

        extTelephonyManager.connectService(serviceCallback)

        registerCarrierConfigReceiver()
    }

    override fun onDestroy() {
        extTelephonyManager.disconnectService(serviceCallback)

        super.onDestroy()
    }

    private fun registerCarrierConfigReceiver() {
        registerReceiver(
            carrierConfigReceiver,
            IntentFilter(CarrierConfigManager.ACTION_CARRIER_CONFIG_CHANGED)
        )
    }

    private fun updateCarrierNrConfig(bundle: PersistableBundle, slotId: Int) {
        val supportedNrModes =
            bundle.getIntArray(CarrierConfigManager.KEY_CARRIER_NR_AVAILABILITIES_INT_ARRAY)

        val is5gStandalone =
            ArrayUtils.contains(supportedNrModes, CarrierConfigManager.CARRIER_NR_AVAILABILITY_SA)
        val is5gNonStandalone =
            ArrayUtils.contains(supportedNrModes, CarrierConfigManager.CARRIER_NR_AVAILABILITY_NSA)

        val nrConfigType = when {
            is5gNonStandalone && !is5gStandalone -> NrConfig.NR_CONFIG_NSA
            is5gStandalone && !is5gNonStandalone -> NrConfig.NR_CONFIG_SA
            else -> NrConfig.NR_CONFIG_COMBINED_SA_NSA
        }
        val nrConfig = NrConfig(nrConfigType)

        client?.let {
            extTelephonyManager.setNrConfig(slotId, nrConfig, it)
        }
    }

    companion object {
        private val LOG_TAG = QtiTelephonyServiceCompat::class.simpleName!!
    }
}
