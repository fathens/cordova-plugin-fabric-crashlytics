interface Window {
    plugin: Plugin;
}

interface Plugin {
    Fabric: Fabric;
}

declare var plugin: Plugin;

interface Fabric {
    Crashlytics: Crashlytics;
}

interface Crashlytics {
    log(msg: string);
    logException(msg: string);
    crash(msg: string);
    setBool(key: string, value: boolean);
    setDouble(key: string, value: number);
    setFloat(key: string, value: number);
    setInt(key: string, value: number);
    setUserIdentifier(value: string);
    setUserName(value: string);
    setUserEmail(value: string);
}
