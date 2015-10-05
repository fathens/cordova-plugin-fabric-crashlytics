package org.fathens.cordova.plugin.fabric;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;

import com.crashlytics.android.Crashlytics;

public class FabricCrashlytics {
	static public Runnable execute(final String action, final JSONArray data, final CallbackContext callbackContext)
			throws JSONException {
		try {
			final Class<FabricCrashlytics> obj = FabricCrashlytics.class;
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

	static Runnable log(final JSONArray args, final CallbackContext context) throws JSONException {
		final String msg = args.getString(0);
		return new Runnable() {
			public void run() {
				Crashlytics.log(msg);
				context.success();
			}
		};
	}

	static Runnable setBool(final JSONArray args, final CallbackContext context) throws JSONException {
		final String key = args.getString(0);
		final boolean value = args.getBoolean(1);
		return new Runnable() {
			public void run() {
				Crashlytics.setBool(key, value);
				context.success();
			}
		};
	}

	static Runnable setDouble(final JSONArray args, final CallbackContext context) throws JSONException {
		final String key = args.getString(0);
		final double value = args.getDouble(1);
		return new Runnable() {
			public void run() {
				Crashlytics.setDouble(key, value);
				context.success();
			}
		};
	}

	static Runnable setFloat(final JSONArray args, final CallbackContext context) throws JSONException {
		final String key = args.getString(0);
		final float value = new Double(args.getDouble(1)).floatValue();
		return new Runnable() {
			public void run() {
				Crashlytics.setFloat(key, value);
				context.success();
			}
		};
	}

	static Runnable setInt(final JSONArray args, final CallbackContext context) throws JSONException {
		final String key = args.getString(0);
		final int value = args.getInt(1);
		return new Runnable() {
			public void run() {
				Crashlytics.setInt(key, value);
				context.success();
			}
		};
	}

	static Runnable setUserIdentifier(final JSONArray args, final CallbackContext context) throws JSONException {
		final String identifier = args.getString(0);
		return new Runnable() {
			public void run() {
				Crashlytics.setUserIdentifier(identifier);
				context.success();
			}
		};
	}

	static Runnable setUserName(final JSONArray args, final CallbackContext context) throws JSONException {
		final String name = args.getString(0);
		return new Runnable() {
			public void run() {
				Crashlytics.setUserName(name);
				context.success();
			}
		};
	}

	static Runnable setUserEmail(final JSONArray args, final CallbackContext context) throws JSONException {
		final String email = args.getString(0);
		return new Runnable() {
			public void run() {
				Crashlytics.setUserEmail(email);
				context.success();
			}
		};
	}

	static Runnable logException(final JSONArray args, final CallbackContext context) throws JSONException {
		final String msg = args.getString(0);
		return new Runnable() {
			public void run() {
				Crashlytics.logException(new RuntimeException(msg));
				context.success();
			}
		};
	}

	static Runnable crash(final JSONArray args, final CallbackContext context) throws JSONException {
		final String msg = args.getString(0);
		return new Runnable() {
			public void run() {
				throw new RuntimeException(msg);
			}
		};
	}
}
