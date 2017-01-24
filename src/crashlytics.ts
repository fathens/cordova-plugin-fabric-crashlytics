import _ from "lodash";
import { Logger } from "log4ts";

const plugin = (window as any).plugin;

const logger = new Logger("Crashlytics");

export interface CrashlyticsClient {
    log(resolve, reject, msg: string): Promise<void>;
    logException(resolve, reject, msg: string): Promise<void>;
    crash(resolve, reject, msg: string): Promise<void>;
    setBool(resolve, reject, key: string, value: boolean): Promise<void>;
    setDouble(resolve, reject, key: string, value: number): Promise<void>;
    setFloat(resolve, reject, key: string, value: number): Promise<void>;
    setInt(resolve, reject, key: string, value: number): Promise<void>;
    setUserIdentifier(resolve, reject, value: string): Promise<void>;
    setUserName(resolve, reject, value: string): Promise<void>;
    setUserEmail(resolve, reject, value: string): Promise<void>;
}

export class Crashlytics {
    private static _client: CrashlyticsClient;
    private static get client(): CrashlyticsClient {
        function isDef(typedec) {
            return !_.isEqual(typedec, 'undefined');
        }
        if (!Crashlytics._client) {
            if (isDef(typeof plugin) && isDef(typeof plugin.Fabric) && isDef(typeof plugin.Fabric.Crashlytics)) {
                Crashlytics._client = plugin.Fabric.Crashlytics;
            }
        }
        return Crashlytics._client;
    }

    static async log(msg: string): Promise<void> {
        if (Crashlytics.client) {
            return new Promise<void>((resolve, reject) => Crashlytics.client.log(resolve, reject, msg));
        }
    }

    static async logException(msg: string): Promise<void> {
        if (Crashlytics.client) {
            return new Promise<void>((resolve, reject) => Crashlytics.client.logException(resolve, reject, msg));
        } else {
            logger.warn(() => `logException: ${msg}`);
        }
    }

    static async crash(msg: string): Promise<void> {
        if (Crashlytics.client) {
            return new Promise<void>((resolve, reject) => Crashlytics.client.crash(resolve, reject, msg));
        } else {
            logger.fatal(() => `crash: ${msg}`);
        }
    }

    static async setBool(key: string, value: boolean): Promise<void> {
        if (Crashlytics.client) {
            return new Promise<void>((resolve, reject) => Crashlytics.client.setBool(resolve, reject, key, value));
        } else {
            logger.info(() => `No Fabric! setBool ${key} = ${value}`);
        }
    }

    static async setDouble(key: string, value: number): Promise<void> {
        if (Crashlytics.client) {
            return new Promise<void>((resolve, reject) => Crashlytics.client.setDouble(resolve, reject, key, value));
        } else {
            logger.info(() => `No Fabric! setDouble ${key} = ${value}`);
        }
    }

    static async setFloat(key: string, value: number): Promise<void> {
        if (Crashlytics.client) {
            return new Promise<void>((resolve, reject) => Crashlytics.client.setFloat(resolve, reject, key, value));
        } else {
            logger.info(() => `No Fabric! setFloat ${key} = ${value}`);
        }
    }

    static async setInt(key: string, value: number): Promise<void> {
        if (Crashlytics.client) {
            return new Promise<void>((resolve, reject) => Crashlytics.client.setInt(resolve, reject, key, value));
        } else {
            logger.info(() => `No Fabric! setInt ${key} = ${value}`);
        }
    }

    static async setUserIdentifier(value: string): Promise<void> {
        if (Crashlytics.client) {
            return new Promise<void>((resolve, reject) => Crashlytics.client.setUserIdentifier(resolve, reject, value));
        } else {
            logger.info(() => `No Fabric! set userIdentifier = ${value}`);
        }
    }

    static async setUserName(value: string): Promise<void> {
        if (Crashlytics.client) {
            return new Promise<void>((resolve, reject) => Crashlytics.client.setUserName(resolve, reject, value));
        } else {
            logger.info(() => `No Fabric! set userNmae = ${value}`);
        }
    }

    static async setUserEmail(value: string): Promise<void> {
        if (Crashlytics.client) {
            return new Promise<void>((resolve, reject) => Crashlytics.client.setUserEmail(resolve, reject, value));
        } else {
            logger.info(() => `No Fabric! set userEmail = ${value}`);
        }
    }
}
