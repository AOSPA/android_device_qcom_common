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
import com.qti.extphone.Client
import com.qti.extphone.ExtPhoneCallbackListener
import com.qti.extphone.ExtTelephonyManager
import com.qti.extphone.NrConfig
import com.qti.extphone.ServiceCallback
import com.qti.extphone.Status
import com.qti.extphone.Token
import java.util.concurrent.CompletableFuture
import java.util.concurrent.TimeUnit

class QtiTelephonyServiceCompat : Service() {
    @Volatile
    private var client: Client? = null
    private var serviceConnected = false

    @Volatile
    private var pendingQueryNrConfig: PendingNrConfig? = null

    @Volatile
    private var pendingSetNrConfig: PendingSetNrConfig? = null

    private val carrierConfigManager by lazy { getSystemService(CarrierConfigManager::class.java) }
    private val extTelephonyManager by lazy { ExtTelephonyManager.getInstance(applicationContext) }
    private val subscriptionManager by lazy { getSystemService(SubscriptionManager::class.java) }

    private val callbackLock = Any()
    private val updateLock = Any()

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
            Log.d(
                LOG_TAG,
                "onNrConfigStatus: slotId = $slotId, token = $token, status = $status, " +
                    "nrConfig = $configStr",
            )
            synchronized(callbackLock) {
                val pending = pendingQueryNrConfig ?: return
                if (pending.token == token?.get()) {
                    if (status?.get() == Status.SUCCESS && nrConfig != null) {
                        pending.future.complete(nrConfig.get())
                    } else {
                        pending.future.complete(null)
                    }
                }
            }
        }

        override fun onSetNrConfig(slotId: Int, token: Token?, status: Status?) {
            Log.d(LOG_TAG, "onSetNrConfig: slotId = $slotId, token = $token, status = $status")
            synchronized(callbackLock) {
                val pending = pendingSetNrConfig ?: return
                if (pending.token == token?.get()) {
                    pending.future.complete(status?.get() == Status.SUCCESS)
                }
            }
        }
    }

    private val serviceCallback = object : ServiceCallback {
        override fun onConnected() {
            Log.d(LOG_TAG, "Connected to ExtTelephonyService")
            serviceConnected = true
            if (registerExtPhoneCallback()) {
                updateAllActiveSubscriptions()
            }
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
                updateCarrierNrConfig(subId, slotId)
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

    @RequiresPermission(Manifest.permission.READ_PHONE_STATE)
    private fun updateAllActiveSubscriptions() {
        subscriptionManager.activeSubscriptionInfoList?.forEach { subInfo ->
            updateCarrierNrConfig(subInfo.subscriptionId, subInfo.simSlotIndex)
        }
    }

    private fun updateCarrierNrConfig(subId: Int, slotId: Int) {
        synchronized(updateLock) {
            if (!ensureExtTelephonyReady()) {
                Log.d(
                    LOG_TAG,
                    "updateCarrierNrConfig: ExtTelephony not ready, will retry on connect",
                )
                return
            }

            val bundle = carrierConfigManager.getConfigForSubId(
                subId,
                CarrierConfigManager.KEY_CARRIER_NR_AVAILABILITIES_INT_ARRAY,
            )
            val nrConfigType = getCarrierNrConfigType(bundle)
            setNrConfig(slotId, nrConfigType)
        }
    }

    private fun getCarrierNrConfigType(bundle: PersistableBundle?): Int {
        if (!CarrierConfigManager.isConfigForIdentifiedCarrier(bundle)) {
            return NrConfig.NR_CONFIG_NSA
        }

        val supportedNrModes =
            bundle?.getIntArray(CarrierConfigManager.KEY_CARRIER_NR_AVAILABILITIES_INT_ARRAY)

        if (supportedNrModes == null || supportedNrModes.isEmpty()) {
            return NrConfig.NR_CONFIG_NSA
        }

        val is5gStandalone =
            supportedNrModes.contains(CarrierConfigManager.CARRIER_NR_AVAILABILITY_SA)
        val is5gNonStandalone =
            supportedNrModes.contains(CarrierConfigManager.CARRIER_NR_AVAILABILITY_NSA)

        return when {
            is5gStandalone && is5gNonStandalone -> NrConfig.NR_CONFIG_COMBINED_SA_NSA
            is5gStandalone -> NrConfig.NR_CONFIG_SA
            else -> NrConfig.NR_CONFIG_NSA
        }
    }

    private fun setNrConfig(slotId: Int, nrConfigType: Int): Boolean {
        val currentNrConfigType = queryNrConfig(slotId)
        if (currentNrConfigType == nrConfigType) {
            Log.d(LOG_TAG, "setNrConfig: slotId = $slotId already mode = $nrConfigType")
            return true
        }

        val pending = synchronized(callbackLock) {
            val extPhoneClient = client ?: return false
            val token = extTelephonyManager.setNrConfig(
                slotId,
                NrConfig(nrConfigType),
                extPhoneClient,
            )
                ?: run {
                    Log.e(LOG_TAG, "setNrConfig: null token for slotId = $slotId")
                    return false
                }

            PendingSetNrConfig(token.get(), CompletableFuture()).also {
                pendingSetNrConfig = it
                Log.d(
                    LOG_TAG,
                    "setNrConfig: slotId = $slotId, token = $token, mode = $nrConfigType",
                )
            }
        }

        return try {
            val success = pending.future.get(NR_CONFIG_TIMEOUT_MS, TimeUnit.MILLISECONDS)
            if (!success) {
                Log.e(LOG_TAG, "setNrConfig: failed for slotId = $slotId, mode = $nrConfigType")
            }
            success
        } catch (e: Exception) {
            Log.e(LOG_TAG, "setNrConfig: timed out for slotId = $slotId, mode = $nrConfigType", e)
            false
        } finally {
            if (pendingSetNrConfig === pending) {
                pendingSetNrConfig = null
            }
        }
    }

    private fun queryNrConfig(slotId: Int): Int? {
        val pending = synchronized(callbackLock) {
            val extPhoneClient = client ?: return null
            val token = extTelephonyManager.queryNrConfig(slotId, extPhoneClient)
                ?: run {
                    Log.e(LOG_TAG, "queryNrConfig: null token for slotId = $slotId")
                    return null
                }

            PendingNrConfig(token.get(), CompletableFuture()).also {
                pendingQueryNrConfig = it
                Log.d(LOG_TAG, "queryNrConfig: slotId = $slotId, token = $token")
            }
        }

        return try {
            val nrConfigType = pending.future.get(NR_CONFIG_TIMEOUT_MS, TimeUnit.MILLISECONDS)
            if (nrConfigType == null) {
                Log.e(LOG_TAG, "queryNrConfig: failed for slotId = $slotId")
            }
            nrConfigType
        } catch (e: Exception) {
            Log.e(LOG_TAG, "queryNrConfig: timed out for slotId = $slotId", e)
            null
        } finally {
            if (pendingQueryNrConfig === pending) {
                pendingQueryNrConfig = null
            }
        }
    }

    private fun ensureExtTelephonyReady(): Boolean {
        if (!extTelephonyManager.isServiceConnected) {
            extTelephonyManager.connectService(serviceCallback)
            return false
        }
        if (client != null) {
            return true
        }

        return registerExtPhoneCallback()
    }

    private fun registerExtPhoneCallback(): Boolean {
        client = extTelephonyManager.registerCallbackWithEvents(
            applicationContext.packageName,
            extPhoneCallbackListener,
            intArrayOf(
                ExtPhoneCallbackListener.EVENT_ON_NR_CONFIG_STATUS,
                ExtPhoneCallbackListener.EVENT_ON_SET_NR_CONFIG,
            ),
        )
        if (client == null) {
            Log.e(LOG_TAG, "registerExtPhoneCallback: failed")
            return false
        }
        return true
    }

    private data class PendingNrConfig(
        val token: Int,
        val future: CompletableFuture<Int?>,
    )

    private data class PendingSetNrConfig(
        val token: Int,
        val future: CompletableFuture<Boolean>,
    )

    companion object {
        private val LOG_TAG = QtiTelephonyServiceCompat::class.simpleName!!
        private const val NR_CONFIG_TIMEOUT_MS = 2000L
    }
}
