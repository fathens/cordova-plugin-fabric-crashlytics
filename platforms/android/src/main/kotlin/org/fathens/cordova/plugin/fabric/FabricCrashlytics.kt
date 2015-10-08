package org.fathens.cordova.plugin.fabric

import org.apache.cordova.CallbackContext
import org.apache.cordova.CordovaPlugin
import org.json.JSONArray
import com.crashlytics.android.Crashlytics

public class FabricCrashlytics : CordovaPlugin() {
    override fun execute(action: String, data: JSONArray, callbackContext: CallbackContext): Boolean {
        try {
            val method = javaClass.getMethod(action, JSONArray::class.java, CallbackContext::class.java)
            val runner = method.invoke(this, data, callbackContext) as (() -> Unit)
            cordova.getThreadPool().execute(runner)
            return true
        } catch (e: NoSuchMethodException) {
            return false
        }
    }

    public fun log(args: JSONArray, context: CallbackContext): (() -> Unit) {
        val msg = args.getString(0)
        return {
            Crashlytics.log(msg)
            context.success()
        }
    }

    public fun setBool(args: JSONArray, context: CallbackContext): (() -> Unit) {
        val key = args.getString(0)
        val value = args.getBoolean(1)
        return {
            Crashlytics.setBool(key, value)
            context.success()
        }
    }

    public fun setDouble(args: JSONArray, context: CallbackContext): (() -> Unit) {
        val key = args.getString(0)
        val value = args.getDouble(1)
        return {
            Crashlytics.setDouble(key, value)
            context.success()
        }
    }

    public fun setFloat(args: JSONArray, context: CallbackContext): (() -> Unit) {
        val key = args.getString(0)
        val value = args.getDouble(1).toFloat()
        return {
            Crashlytics.setFloat(key, value)
            context.success()
        }
    }

    public fun setInt(args: JSONArray, context: CallbackContext): (() -> Unit) {
        val key = args.getString(0)
        val value = args.getInt(1)
        return {
            Crashlytics.setInt(key, value)
            context.success()
        }
    }

    public fun setUserIdentifier(args: JSONArray, context: CallbackContext): (() -> Unit) {
        val identifier = args.getString(0)
        return {
            Crashlytics.setUserIdentifier(identifier)
            context.success()
        }
    }

    public fun setUserName(args: JSONArray, context: CallbackContext): (() -> Unit) {
        val name = args.getString(0)
        return {
            Crashlytics.setUserName(name)
            context.success()
        }
    }

    public fun setUserEmail(args: JSONArray, context: CallbackContext): (() -> Unit) {
        val email = args.getString(0)
        return {
            Crashlytics.setUserEmail(email)
            context.success()
        }
    }

    public fun logException(args: JSONArray, context: CallbackContext): (() -> Unit) {
        val msg = args.getString(0)
        return {
            Crashlytics.logException(RuntimeException(msg))
            context.success()
        }
    }

    public fun crash(args: JSONArray, context: CallbackContext): (() -> Unit) {
        val msg = args.getString(0)
        return {
            throw RuntimeException(msg)
        }
    }
}
