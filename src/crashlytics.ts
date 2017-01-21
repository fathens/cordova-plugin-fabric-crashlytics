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

export class Crashlytics implements CrashlyticsClient {
    constructor() {
        this.client = hasPlugin ? plugin.Fabric.Crashlytics : null;
    }

    private client: CrashlyticsClient;

    async log(msg: string): Promise<void> {
        if (this.client) {
            return this.client.log(msg);
        } else {
            logger.info(msg);
        }
    }

    async logException(msg: string): Promise<void> {
        if (this.client) {
            return this.client.logException(msg);
        } else {
            logger.warn(msg);
        }
    }

    async crash(msg: string): Promise<void> {
        if (this.client) {
            return this.client.crash(msg);
        } else {
            logger.fatal(msg);
        }
    }

    async setBool(key: string, value: boolean): Promise<void> {
        if (this.client) {
            return this.client.setBool(key, value);
        } else {
            logger.info(`No Fabric here ! set ${key} = ${value}`);
        }
    }

    async setDouble(key: string, value: number): Promise<void> {
        if (this.client) {
            return this.client.setDouble(key, value);
        } else {
            logger.info(`No Fabric here ! set ${key} = ${value}`);
        }
    }

    async setFloat(key: string, value: number): Promise<void> {
        if (this.client) {
            return this.client.setFloat(key, value);
        } else {
            logger.info(`No Fabric here ! set ${key} = ${value}`);
        }
    }

    async setInt(key: string, value: number): Promise<void> {
        if (this.client) {
            return this.client.setInt(key, value);
        } else {
            logger.info(`No Fabric here ! set ${key} = ${value}`);
        }
    }

    async setUserIdentifier(value: string): Promise<void> {
        if (this.client) {
            return this.client.setUserIdentifier(value);
        } else {
            logger.info(`No Fabric here ! set userIdentifier = ${value}`);
        }
    }

    async setUserName(value: string): Promise<void> {
        if (this.client) {
            return this.client.setUserName(value);
        } else {
            logger.info(`No Fabric here ! set userNmae = ${value}`);
        }
    }

    async setUserEmail(value: string): Promise<void> {
        if (this.client) {
            return this.client.setUserEmail(value);
        } else {
            logger.info(`No Fabric here ! set userEmail = ${value}`);
        }
    }
}
