

export declare class MessageUnPackerTs {
    unpackBool(): boolean
    unpackInt8(): number
    unpackInt16(): number
    unpackInt32(): number
    unpackInt64(): number
    unpackString(): string
    unpackFloat64(): number
    unpackNull(): void
    unpackArray(): Array<number>
    unpackMapHeader(): number
    unpackArrayHeader(): number
    unpackTimestamp(): number
    unpackExtensionTypeHeader(): Array<number>
    readPayload(value: number): Array<number>

    constructor (value: Array<number>) //
}



import { MultiNavigation } from "@kit.ArkUI";


export declare class MessagePackerTs {
    packBool(value: boolean): void
    packInt8(value: number): void
    packInt16(value: number): void
    packInt32(value: number): void
    packInt64(value: number): void
    packString(value: string): void
    packFloat64(value: number): void
    packArray(value: Array<number>): void
    packMapHeader(value: number): void
    packArrayHeader(value: number): void
    packTimestamp(value: number): void
    packExtensionTypeHeader(extType: number, payloadLen: number): void
    writePayload(value: Array<number>): void
    packJson(value: string): void
    packNull(): void
    toByteArray(): Array<number>

    constructor () //
}

export declare class DataModelTs {

    packJson(value: string): Array<number>
    unpackJson(value: Array<number>): string

    constructor () //
}

