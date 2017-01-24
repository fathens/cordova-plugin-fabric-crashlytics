import _ from "lodash";
import { Logger } from "log4ts";

const plugin = (window as any).plugin;

const logger = new Logger("Crashlytics");

function isDef(typedec) {
    return !_.isEqual(typedec, 'undefined');
}
function hasPlugin(): boolean {
    return isDef(typeof plugin) && isDef(typeof plugin.Fabric) && isDef(typeof plugin.Fabric.Crashlytics);
}

export interface CrashlyticsClient {
    log(msg: string): Promise<void>;
    logException(msg: string): Promise<void>;
    crash(msg: string): Promise<void>;
    setBool(key: string, value: boolean): Promise<void>;
    setDouble(key: string, value: number): Promise<void>;
    setFloat(key: string, value: number): Promise<void>;
    setInt(key: string, value: number): Promise<void>;
    setUserIdentifier(value: string): Promise<void>;
    setUserName(value: string): Promise<void>;
    setUserEmail(value: string): Promise<void>;
}

export class Crashlytics {
    private static get client(): CrashlyticsClient {
        return hasPlugin() ? plugin.Fabric.Crashlytics : null;
    }

    static async log(msg: string): Promise<void> {
        if (Crashlytics.client) {
            return Crashlytics.client.log(msg);
        }
    }

    static async logException(msg: string): Promise<void> {
        if (Crashlytics.client) {
            return Crashlytics.client.logException(msg);
        } else {
            logger.warn(() => `logException: ${msg}`);
        }
    }

    static async crash(msg: string): Promise<void> {
        if (Crashlytics.client) {
            return Crashlytics.client.crash(msg);
        } else {
            logger.fatal(() => `crash: ${msg}`);
        }
    }

    static async setBool(key: string, value: boolean): Promise<void> {
        if (Crashlytics.client) {
            return Crashlytics.client.setBool(key, value);
        } else {
            logger.info(() => `No Fabric! setBool ${key} = ${value}`);
        }
    }

    static async setDouble(key: string, value: number): Promise<void> {
        if (Crashlytics.client) {
            return Crashlytics.client.setDouble(key, value);
        } else {
            logger.info(() => `No Fabric! setDouble ${key} = ${value}`);
        }
    }

    static async setFloat(key: string, value: number): Promise<void> {
        if (Crashlytics.client) {
            return Crashlytics.client.setFloat(key, value);
        } else {
            logger.info(() => `No Fabric! setFloat ${key} = ${value}`);
        }
    }

    static async setInt(key: string, value: number): Promise<void> {
        if (Crashlytics.client) {
            return Crashlytics.client.setInt(key, value);
        } else {
            logger.info(() => `No Fabric! setInt ${key} = ${value}`);
        }
    }

    static async setUserIdentifier(value: string): Promise<void> {
        if (Crashlytics.client) {
            return Crashlytics.client.setUserIdentifier(value);
        } else {
            logger.info(() => `No Fabric! set userIdentifier = ${value}`);
        }
    }

    static async setUserName(value: string): Promise<void> {
        if (Crashlytics.client) {
            return Crashlytics.client.setUserName(value);
        } else {
            logger.info(() => `No Fabric! set userNmae = ${value}`);
        }
    }

    static async setUserEmail(value: string): Promise<void> {
        if (Crashlytics.client) {
            return Crashlytics.client.setUserEmail(value);
        } else {
            logger.info(() => `No Fabric! set userEmail = ${value}`);
        }
    }
}
