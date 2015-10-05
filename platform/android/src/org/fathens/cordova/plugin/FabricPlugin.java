package org.fathens.cordova.plugin;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

public class FabricPlugin extends CordovaPlugin {
	@Override
	public boolean execute(final String action, final JSONArray data, final CallbackContext callbackContext) throws JSONException {
		Runnable runner = null;
		if (runner == null) runner = FabricCrashlytics.execute(action, data, callbackContext);
		if (runner == null) runner = FabricAnswers.execute(action, data, callbackContext);
		
		if (runner != null) {
			cordova.getThreadPool().execute(runner);
			return true;
		} else {
			return false;
		}
	}
}
