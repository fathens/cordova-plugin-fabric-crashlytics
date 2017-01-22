import _ from "lodash";
import { Logger } from "log4ts";

const plugin = (window as any).plugin;

const logger = new Logger("S3File");

function isDef(typedec) {
    return !_.isEqual(typedec, 'undefined');
}
const hasPlugin = isDef(typeof plugin) && isDef(typeof plugin.Fabric) && isDef(typeof plugin.Fabric.Crashlytics);

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

const client: CrashlyticsClient = hasPlugin ? plugin.Fabric.Crashlytics : null;

export class Crashlytics {
    static async log(msg: string): Promise<void> {
        if (client) {
            return client.log(msg);
        }
    }

    static async logException(msg: string): Promise<void> {
        if (client) {
            return client.logException(msg);
        } else {
            logger.warn(msg);
        }
    }

    static async crash(msg: string): Promise<void> {
        if (client) {
            return client.crash(msg);
        } else {
            logger.fatal(msg);
        }
    }

    static async setBool(key: string, value: boolean): Promise<void> {
        if (client) {
            return client.setBool(key, value);
        } else {
            logger.info(`No Fabric here ! set ${key} = ${value}`);
        }
    }

    static async setDouble(key: string, value: number): Promise<void> {
        if (client) {
            return client.setDouble(key, value);
        } else {
            logger.info(`No Fabric here ! set ${key} = ${value}`);
        }
    }

    static async setFloat(key: string, value: number): Promise<void> {
        if (client) {
            return client.setFloat(key, value);
        } else {
            logger.info(`No Fabric here ! set ${key} = ${value}`);
        }
    }

    static async setInt(key: string, value: number): Promise<void> {
        if (client) {
            return client.setInt(key, value);
        } else {
            logger.info(`No Fabric here ! set ${key} = ${value}`);
        }
    }

    static async setUserIdentifier(value: string): Promise<void> {
        if (client) {
            return client.setUserIdentifier(value);
        } else {
            logger.info(`No Fabric here ! set userIdentifier = ${value}`);
        }
    }

    static async setUserName(value: string): Promise<void> {
        if (client) {
            return client.setUserName(value);
        } else {
            logger.info(`No Fabric here ! set userNmae = ${value}`);
        }
    }

    static async setUserEmail(value: string): Promise<void> {
        if (client) {
            return client.setUserEmail(value);
        } else {
            logger.info(`No Fabric here ! set userEmail = ${value}`);
        }
    }
}
