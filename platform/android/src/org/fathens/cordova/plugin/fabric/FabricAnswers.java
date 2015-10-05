package org.fathens.cordova.plugin.fabric;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.util.Currency;
import java.util.Iterator;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.crashlytics.android.answers.AddToCartEvent;
import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.AnswersEvent;
import com.crashlytics.android.answers.ContentViewEvent;
import com.crashlytics.android.answers.CustomEvent;
import com.crashlytics.android.answers.InviteEvent;
import com.crashlytics.android.answers.LevelEndEvent;
import com.crashlytics.android.answers.LevelStartEvent;
import com.crashlytics.android.answers.LoginEvent;
import com.crashlytics.android.answers.PurchaseEvent;
import com.crashlytics.android.answers.RatingEvent;
import com.crashlytics.android.answers.SearchEvent;
import com.crashlytics.android.answers.ShareEvent;
import com.crashlytics.android.answers.SignUpEvent;
import com.crashlytics.android.answers.StartCheckoutEvent;

public class FabricAnswers {
	static public Runnable execute(final String action, final JSONArray data, final CallbackContext callbackContext)
			throws JSONException {
		try {
			final Class<FabricAnswers> obj = FabricAnswers.class;
			final Method method = obj.getMethod(action, JSONArray.class, CallbackContext.class);
			return (Runnable) method.invoke(obj, data, callbackContext);
		} catch (NoSuchMethodException e) {
			return null;
		} catch (IllegalAccessException ex) {
			throw new RuntimeException(ex);
		} catch (IllegalArgumentException ex) {
			throw new RuntimeException(ex);
		} catch (InvocationTargetException ex) {
			throw new RuntimeException(ex);
		}
	}

	static public void putCustom(AnswersEvent<?> event, JSONObject custom) throws JSONException {
		for (@SuppressWarnings("unchecked")
		Iterator<String> iterator = custom.keys(); iterator.hasNext();) {
			final String key = iterator.next();
			final Object value = custom.get(key);
			if (value instanceof String)
				event.putCustomAttribute(key, (String) value);
			if (value instanceof Number)
				event.putCustomAttribute(key, (Number) value);
		}
	}

	static public Runnable eventPurchase(final JSONArray args, final CallbackContext context) throws JSONException {
		final JSONObject obj = args.getJSONObject(0);
		return new Runnable() {
			public void run() {
				try {
					final PurchaseEvent event = new PurchaseEvent();
					if (obj.has("itemPrice"))
						event.putItemPrice(new BigDecimal(obj.getInt("itemPrice")));
					if (obj.has("currency"))
						event.putCurrency(Currency.getInstance(obj.getString("currency")));
					if (obj.has("itemName"))
						event.putItemName(obj.getString("itemName"));
					if (obj.has("itemType"))
						event.putItemType(obj.getString("itemType"));
					if (obj.has("itemId"))
						event.putItemId(obj.getString("itemId"));
					if (obj.has("success"))
						event.putSuccess(obj.getBoolean("success"));
					if (obj.has("custom")) {
						putCustom(event, obj.getJSONObject("custom"));
					}
					Answers.getInstance().logPurchase(event);
					context.success();
				} catch (Exception ex) {
					throw new RuntimeException(ex);
				}
			}
		};
	}

	static public Runnable eventAddToCart(final JSONArray args, final CallbackContext context) throws JSONException {
		final JSONObject obj = args.getJSONObject(0);
		return new Runnable() {
			public void run() {
				try {
					final AddToCartEvent event = new AddToCartEvent();
					if (obj.has("itemPrice"))
						event.putItemPrice(new BigDecimal(obj.getInt("itemPrice")));
					if (obj.has("currency"))
						event.putCurrency(Currency.getInstance(obj.getString("currency")));
					if (obj.has("itemName"))
						event.putItemName(obj.getString("itemName"));
					if (obj.has("itemType"))
						event.putItemType(obj.getString("itemType"));
					if (obj.has("itemId"))
						event.putItemId(obj.getString("itemId"));
					if (obj.has("custom")) {
						putCustom(event, obj.getJSONObject("custom"));
					}
					Answers.getInstance().logAddToCart(event);
					context.success();
				} catch (Exception ex) {
					throw new RuntimeException(ex);
				}
			}
		};
	}

	static public Runnable eventStartCheckout(final JSONArray args, final CallbackContext context) throws JSONException {
		final JSONObject obj = args.getJSONObject(0);
		return new Runnable() {
			public void run() {
				try {
					final StartCheckoutEvent event = new StartCheckoutEvent();
					if (obj.has("totalPrice"))
						event.putTotalPrice(new BigDecimal(obj.getInt("totalPrice")));
					if (obj.has("currency"))
						event.putCurrency(Currency.getInstance(obj.getString("currency")));
					if (obj.has("itemCount"))
						event.putItemCount(obj.getInt("itemCount"));
					if (obj.has("custom")) {
						putCustom(event, obj.getJSONObject("custom"));
					}
					Answers.getInstance().logStartCheckout(event);
					context.success();
				} catch (Exception ex) {
					throw new RuntimeException(ex);
				}
			}
		};
	}

	static public Runnable eventContentView(final JSONArray args, final CallbackContext context) throws JSONException {
		final JSONObject obj = args.getJSONObject(0);
		return new Runnable() {
			public void run() {
				try {
					final ContentViewEvent event = new ContentViewEvent();
					if (obj.has("contentName"))
						event.putContentName(obj.getString("contentName"));
					if (obj.has("contentType"))
						event.putContentType(obj.getString("contentType"));
					if (obj.has("contentId"))
						event.putContentId(obj.getString("contentId"));
					if (obj.has("custom")) {
						putCustom(event, obj.getJSONObject("custom"));
					}
					Answers.getInstance().logContentView(event);
					context.success();
				} catch (Exception ex) {
					throw new RuntimeException(ex);
				}
			}
		};
	}

	static public Runnable eventSearch(final JSONArray args, final CallbackContext context) throws JSONException {
		final JSONObject obj = args.getJSONObject(0);
		return new Runnable() {
			public void run() {
				try {
					final SearchEvent event = new SearchEvent();
					if (obj.has("query"))
						event.putQuery(obj.getString("query"));
					if (obj.has("custom")) {
						putCustom(event, obj.getJSONObject("custom"));
					}
					Answers.getInstance().logSearch(event);
					context.success();
				} catch (Exception ex) {
					throw new RuntimeException(ex);
				}
			}
		};
	}

	static public Runnable eventShare(final JSONArray args, final CallbackContext context) throws JSONException {
		final JSONObject obj = args.getJSONObject(0);
		return new Runnable() {
			public void run() {
				try {
					final ShareEvent event = new ShareEvent();
					if (obj.has("method"))
						event.putMethod(obj.getString("method"));
					if (obj.has("contentName"))
						event.putContentName(obj.getString("contentName"));
					if (obj.has("contentType"))
						event.putContentType(obj.getString("contentType"));
					if (obj.has("contentId"))
						event.putContentId(obj.getString("contentId"));
					if (obj.has("custom")) {
						putCustom(event, obj.getJSONObject("custom"));
					}
					Answers.getInstance().logShare(event);
					context.success();
				} catch (Exception ex) {
					throw new RuntimeException(ex);
				}
			}
		};
	}

	static public Runnable eventRating(final JSONArray args, final CallbackContext context) throws JSONException {
		final JSONObject obj = args.getJSONObject(0);
		return new Runnable() {
			public void run() {
				try {
					final RatingEvent event = new RatingEvent();
					if (obj.has("rating"))
						event.putRating(obj.getInt("rating"));
					if (obj.has("contentName"))
						event.putContentName(obj.getString("contentName"));
					if (obj.has("contentType"))
						event.putContentType(obj.getString("contentType"));
					if (obj.has("contentId"))
						event.putContentId(obj.getString("contentId"));
					if (obj.has("custom")) {
						putCustom(event, obj.getJSONObject("custom"));
					}
					Answers.getInstance().logRating(event);
					context.success();
				} catch (Exception ex) {
					throw new RuntimeException(ex);
				}
			}
		};
	}

	static public Runnable eventSignUp(final JSONArray args, final CallbackContext context) throws JSONException {
		final JSONObject obj = args.getJSONObject(0);
		return new Runnable() {
			public void run() {
				try {
					final SignUpEvent event = new SignUpEvent();
					if (obj.has("method"))
						event.putMethod(obj.getString("method"));
					if (obj.has("success"))
						event.putSuccess(obj.getBoolean("success"));
					if (obj.has("custom")) {
						putCustom(event, obj.getJSONObject("custom"));
					}
					Answers.getInstance().logSignUp(event);
					context.success();
				} catch (Exception ex) {
					throw new RuntimeException(ex);
				}
			}
		};
	}

	static public Runnable eventLogin(final JSONArray args, final CallbackContext context) throws JSONException {
		final JSONObject obj = args.getJSONObject(0);
		return new Runnable() {
			public void run() {
				try {
					final LoginEvent event = new LoginEvent();
					if (obj.has("method"))
						event.putMethod(obj.getString("method"));
					if (obj.has("success"))
						event.putSuccess(obj.getBoolean("success"));
					if (obj.has("custom")) {
						putCustom(event, obj.getJSONObject("custom"));
					}
					Answers.getInstance().logLogin(event);
					context.success();
				} catch (Exception ex) {
					throw new RuntimeException(ex);
				}
			}
		};
	}

	static public Runnable eventInvite(final JSONArray args, final CallbackContext context) throws JSONException {
		final JSONObject obj = args.getJSONObject(0);
		return new Runnable() {
			public void run() {
				try {
					final InviteEvent event = new InviteEvent();
					if (obj.has("method"))
						event.putMethod(obj.getString("method"));
					if (obj.has("custom")) {
						putCustom(event, obj.getJSONObject("custom"));
					}
					Answers.getInstance().logInvite(event);
					context.success();
				} catch (Exception ex) {
					throw new RuntimeException(ex);
				}
			}
		};
	}

	static public Runnable eventLevelStart(final JSONArray args, final CallbackContext context) throws JSONException {
		final JSONObject obj = args.getJSONObject(0);
		return new Runnable() {
			public void run() {
				try {
					final LevelStartEvent event = new LevelStartEvent();
					if (obj.has("levelName"))
						event.putLevelName(obj.getString("levelName"));
					if (obj.has("custom")) {
						putCustom(event, obj.getJSONObject("custom"));
					}
					Answers.getInstance().logLevelStart(event);
					context.success();
				} catch (Exception ex) {
					throw new RuntimeException(ex);
				}
			}
		};
	}

	static public Runnable eventLevelEnd(final JSONArray args, final CallbackContext context) throws JSONException {
		final JSONObject obj = args.getJSONObject(0);
		return new Runnable() {
			public void run() {
				try {
					final LevelEndEvent event = new LevelEndEvent();
					if (obj.has("levelName"))
						event.putLevelName(obj.getString("levelName"));
					if (obj.has("score"))
						event.putScore(obj.getInt("score"));
					if (obj.has("success"))
						event.putSuccess(obj.getBoolean("success"));
					if (obj.has("custom")) {
						putCustom(event, obj.getJSONObject("custom"));
					}
					Answers.getInstance().logLevelEnd(event);
					context.success();
				} catch (Exception ex) {
					throw new RuntimeException(ex);
				}
			}
		};
	}

	static public Runnable eventCustom(final JSONArray args, final CallbackContext context) throws JSONException {
		final JSONObject obj = args.getJSONObject(0);
		return new Runnable() {
			public void run() {
				try {
					final CustomEvent event = new CustomEvent(obj.getString("name"));
					if (obj.has("attributes")) {
						putCustom(event, obj.getJSONObject("attributes"));
					}
					Answers.getInstance().logCustom(event);
					context.success();
				} catch (Exception ex) {
					throw new RuntimeException(ex);
				}
			}
		};
	}
}
