package org.fathens.cordova.plugin.fabric

import org.apache.cordova.CallbackContext
import org.apache.cordova.CordovaPlugin
import org.json.JSONArray
import com.crashlytics.android.Crashlytics

public class FabricCrashlytics : CordovaPlugin() {
    override fun execute(action: String, data: JSONArray, callbackContext: CallbackContext): Boolean {
        try {
            val method = javaClass.getMethod(action, data.javaClass)
            val runner = method.invoke(this, data) as (() -> Unit)
            cordova.getThreadPool().execute {
                runner()
                callbackContext.success()
            }
            return true
        } catch (e: NoSuchMethodException) {
            return false
        }
    }

    public fun log(args: JSONArray): (() -> Unit) {
        val msg = args.getString(0)
        return {
            Crashlytics.log(msg)
        }
    }

    public fun setBool(args: JSONArray): (() -> Unit) {
        val key = args.getString(0)
        val value = args.getBoolean(1)
        return {
            Crashlytics.setBool(key, value)
        }
    }

    public fun setDouble(args: JSONArray): (() -> Unit) {
        val key = args.getString(0)
        val value = args.getDouble(1)
        return {
            Crashlytics.setDouble(key, value)
        }
    }

    public fun setFloat(args: JSONArray): (() -> Unit) {
        val key = args.getString(0)
        val value = args.getDouble(1).toFloat()
        return {
            Crashlytics.setFloat(key, value)
        }
    }

    public fun setInt(args: JSONArray): (() -> Unit) {
        val key = args.getString(0)
        val value = args.getInt(1)
        return {
            Crashlytics.setInt(key, value)
        }
    }

    public fun setUserIdentifier(args: JSONArray): (() -> Unit) {
        val identifier = args.getString(0)
        return {
            Crashlytics.setUserIdentifier(identifier)
        }
    }

    public fun setUserName(args: JSONArray): (() -> Unit) {
        val name = args.getString(0)
        return {
            Crashlytics.setUserName(name)
        }
    }

    public fun setUserEmail(args: JSONArray): (() -> Unit) {
        val email = args.getString(0)
        return {
            Crashlytics.setUserEmail(email)
        }
    }

    public fun logException(args: JSONArray): (() -> Unit) {
        val msg = args.getString(0)
        return {
            Crashlytics.logException(RuntimeException(msg))
        }
    }

    public fun crash(args: JSONArray): (() -> Unit) {
        val msg = args.getString(0)
        return {
            throw RuntimeException(msg)
        }
    }
}
