package org.fathens.cordova.plugin.fabric

import java.math.BigDecimal
import java.util.Currency
import org.apache.cordova.CallbackContext
import org.apache.cordova.CordovaPlugin
import org.json.JSONArray
import org.json.JSONObject
import com.crashlytics.android.answers.*

class ParamDict(val obj: JSONObject) {
    fun opt(name: String): Any? = obj.opt(name)

    fun getJSONObject(name: String): JSONObject? = opt(name) as? JSONObject
    fun getString(name: String): String? = opt(name) as? String
    fun getBoolean(name: String): Boolean? = opt(name) as? Boolean
    fun getNumber(name: String): Number? = opt(name) as? Number
    fun getDecimal(name: String): BigDecimal? = getNumber(name)?.let { BigDecimal(it.toDouble()) }
    fun getCurrency(name: String): Currency? = getString(name)?.let { Currency.getInstance(it)}
}

public class FabricAnswers : CordovaPlugin() {
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

    public fun putCustom(event: AnswersEvent<*>, custom: JSONObject) {
        val iterator = custom.keys()
        while (iterator.hasNext()) {
            val key = iterator.next()
            val value = custom.get(key)
            when (value) {
                is String -> event.putCustomAttribute(key, value)
                is Number -> event.putCustomAttribute(key, value)
                else -> event.putCustomAttribute(key, "$value")
            }
        }
    }

    public fun eventPurchase(args: JSONArray): (() -> Unit) {
        val obj = if (args.length() > 0) args.getJSONObject(0) else null
        return {
            val event = PurchaseEvent()
            if (obj != null) {
                val dict = ParamDict(obj)
                dict.getDecimal("itemPrice")?.let { event.putItemPrice(it) }
                dict.getCurrency("currency")?.let { event.putCurrency(it) }
                dict.getString("itemName")?.let { event.putItemName(it) }
                dict.getString("itemType")?.let { event.putItemType(it) }
                dict.getString("itemId")?.let { event.putItemId(it) }
                dict.getBoolean("success")?.let { event.putSuccess(it) }
                dict.getJSONObject("custom")?.let { putCustom(event, it) }
            }
            Answers.getInstance().logPurchase(event)
        }
    }

    public fun eventAddToCart(args: JSONArray): (() -> Unit) {
        val obj = if (args.length() > 0) args.getJSONObject(0) else null
        return {
            val event = AddToCartEvent()
            if (obj != null) {
                val dict = ParamDict(obj)
                dict.getDecimal("itemPrice")?.let { event.putItemPrice(it) }
                dict.getCurrency("currency")?.let { event.putCurrency(it) }
                dict.getString("itemName")?.let { event.putItemName(it) }
                dict.getString("itemType")?.let { event.putItemType(it) }
                dict.getString("itemId")?.let { event.putItemId(it) }
                dict.getJSONObject("custom")?.let { putCustom(event, it) }
            }
            Answers.getInstance().logAddToCart(event)
        }
    }

    public fun eventStartCheckout(args: JSONArray): (() -> Unit) {
        val obj = if (args.length() > 0) args.getJSONObject(0) else null
        return {
            val event = StartCheckoutEvent()
            if (obj != null) {
                val dict = ParamDict(obj)
                dict.getDecimal("totalPrice")?.let { event.putTotalPrice(it) }
                dict.getCurrency("currency")?.let { event.putCurrency(it) }
                dict.getNumber("itemCount")?.let { event.putItemCount(it.toInt()) }
                dict.getJSONObject("custom")?.let { putCustom(event, it) }
            }
            Answers.getInstance().logStartCheckout(event)
        }
    }

    public fun eventContentView(args: JSONArray): (() -> Unit) {
        val obj = if (args.length() > 0) args.getJSONObject(0) else null
        return {
            val event = ContentViewEvent()
            if (obj != null) {
                val dict = ParamDict(obj)
                dict.getString("contentName")?.let { event.putContentName(it) }
                dict.getString("contentType")?.let { event.putContentType(it) }
                dict.getString("contentId")?.let { event.putContentId(it) }
                dict.getJSONObject("custom")?.let { putCustom(event, it) }
            }
            Answers.getInstance().logContentView(event)
        }
    }

    public fun eventSearch(args: JSONArray): (() -> Unit) {
        val obj = if (args.length() > 0) args.getJSONObject(0) else null
        return {
            val event = SearchEvent()
            if (obj != null) {
                val dict = ParamDict(obj)
                dict.getString("query")?.let { event.putQuery(it) }
                dict.getJSONObject("custom")?.let { putCustom(event, it) }
            }
            Answers.getInstance().logSearch(event)
        }
    }

    public fun eventShare(args: JSONArray): (() -> Unit) {
        val obj = if (args.length() > 0) args.getJSONObject(0) else null
        return {
            val event = ShareEvent()
            if (obj != null) {
                val dict = ParamDict(obj)
                dict.getString("method")?.let { event.putMethod(it) }
                dict.getString("contentName")?.let { event.putContentName(it) }
                dict.getString("contentType")?.let { event.putContentType(it) }
                dict.getString("contentId")?.let { event.putContentId(it) }
                dict.getJSONObject("custom")?.let { putCustom(event, it) }
            }
            Answers.getInstance().logShare(event)
        }
    }

    public fun eventRating(args: JSONArray): (() -> Unit) {
        val obj = if (args.length() > 0) args.getJSONObject(0) else null
        return {
            val event = RatingEvent()
            if (obj != null) {
                val dict = ParamDict(obj)
                dict.getNumber("rating")?.let { event.putRating(it.toInt()) }
                dict.getString("contentName")?.let { event.putContentName(it) }
                dict.getString("contentType")?.let { event.putContentType(it) }
                dict.getString("contentId")?.let { event.putContentId(it) }
                dict.getJSONObject("custom")?.let { putCustom(event, it) }
            }
            Answers.getInstance().logRating(event)
        }
    }

    public fun eventSignUp(args: JSONArray): (() -> Unit) {
        val obj = if (args.length() > 0) args.getJSONObject(0) else null
        return {
            val event = SignUpEvent()
            if (obj != null) {
                val dict = ParamDict(obj)
                dict.getString("method")?.let { event.putMethod(it) }
                dict.getBoolean("success")?.let { event.putSuccess(it) }
                dict.getJSONObject("custom")?.let { putCustom(event, it) }
            }
            Answers.getInstance().logSignUp(event)
        }
    }

    public fun eventLogin(args: JSONArray): (() -> Unit) {
        val obj = if (args.length() > 0) args.getJSONObject(0) else null
        return {
            val event = LoginEvent()
            if (obj != null) {
                val dict = ParamDict(obj)
                dict.getString("method")?.let { event.putMethod(it) }
                dict.getBoolean("success")?.let { event.putSuccess(it) }
                dict.getJSONObject("custom")?.let { putCustom(event, it) }
            }
            Answers.getInstance().logLogin(event)
        }
    }

    public fun eventInvite(args: JSONArray): (() -> Unit) {
        val obj = if (args.length() > 0) args.getJSONObject(0) else null
        return {
            val event = InviteEvent()
            if (obj != null) {
                val dict = ParamDict(obj)
                dict.getString("method")?.let { event.putMethod(it) }
                dict.getJSONObject("custom")?.let { putCustom(event, it) }
            }
            Answers.getInstance().logInvite(event)
        }
    }

    public fun eventLevelStart(args: JSONArray): (() -> Unit) {
        val obj = if (args.length() > 0) args.getJSONObject(0) else null
        return {
            val event = LevelStartEvent()
            if (obj != null) {
                val dict = ParamDict(obj)
                dict.getString("levelName")?.let { event.putLevelName(it) }
                dict.getJSONObject("custom")?.let { putCustom(event, it) }
            }
            Answers.getInstance().logLevelStart(event)
        }
    }

    public fun eventLevelEnd(args: JSONArray): (() -> Unit) {
        val obj = if (args.length() > 0) args.getJSONObject(0) else null
        return {
            val event = LevelEndEvent()
            if (obj != null) {
                val dict = ParamDict(obj)
                dict.getString("levelName")?.let { event.putLevelName(it) }
                dict.getNumber("score")?.let { event.putScore(it) }
                dict.getBoolean("success")?.let { event.putSuccess(it) }
                dict.getJSONObject("custom")?.let { putCustom(event, it) }
            }
            Answers.getInstance().logLevelEnd(event)
        }
    }

    public fun eventCustom(args: JSONArray): (() -> Unit) {
        val obj = if (args.length() > 0) args.getJSONObject(0) else null
        return {
            val event = CustomEvent(obj?.let { ParamDict(it) }?.getString("name") ?: "NoName")
            if (obj != null) {
                val dict = ParamDict(obj)
                dict.getJSONObject("attributes")?.let { putCustom(event, it) }
            }
            Answers.getInstance().logCustom(event)
        }
    }
}
