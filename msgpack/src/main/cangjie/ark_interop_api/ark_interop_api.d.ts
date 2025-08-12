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
    unpackExtensionTypeHeader(): Array<number>
    readPayload(value: number): Array<number>
    unpackTimestamp(): number
}

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
    packTimestamp(time: number): void
    packNull(): void
    packExtensionTypeHeader(extType: number, payloadLen: number): void
    writePayload(value: Array<number>): void
    toByteArray(): Array<number>
}

export declare class DataModelTs {
    packJson(value: string): Array<number>
    unpackJson(value: Array<number>): string
}



export declare class DataModelTs {
    packJson(value: string): Array<number> //
}

export declare class MessageUnPackerTs {
    unpackBool(): boolean
    unpackInt8(): number
    unpackInt16(): number
    unpackInt32(): number
    unpackInt64(): number
    unpackString(): string
    unpackFloat64(): number
    unpackArray(): Array<number>
    unpackMapHeader(): number
    unpackArrayHeader(): number //
}

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
    toByteArray(): Array<number> //
}

export declare interface CustomLib {
    DataModelTs: {new (): DataModelTs}
    MessagePackerTs: {new (): MessagePackerTs}
    MessageUnPackerTs: {new (value: Array<number>): MessageUnPackerTs}
}