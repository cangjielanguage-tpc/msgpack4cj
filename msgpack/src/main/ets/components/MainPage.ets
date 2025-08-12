import { DataModelTs, MessagePackerTs, MessageUnPackerTs } from "libmsgpack.so";

// export function packInt8(packer: MessagePacker, value: number) {
//
// }

export class DataModel {
  helper: DataModelTs = new DataModelTs()

  packJson(value: string): Array<number> {
    return this.helper.packJson(value)
  }

  unpackJson(value: Array<number>): string {
    return this.helper.unpackJson(value)
  }

  constructor (){}
}


export class MessagePacker {
  helper: MessagePackerTs = new MessagePackerTs()

  packBool(value: boolean): void {
    this.helper.packBool(value)
  }

  packInt8(value: number): void {
    this.helper.packInt8(value)
  }
  packInt16(value: number): void {
    this.helper.packInt16(value)
  }

  packInt32(value: number): void {
    this.helper.packInt32(value)
  }

  packInt64(value: number): void {
    this.helper.packInt64(value)
  }

  packString(value: string): void {
    this.helper.packString(value)
  }

  packFloat64(value: number): void {
    this.helper.packFloat64(value)
  }

  packArray(value: Array<number>): void {
    this.helper.packArray(value)
  }

  packMapHeader(value: number): void {
    this.helper.packMapHeader(value)
  }

  packArrayHeader(value: number): void {
    this.helper.packArrayHeader(value)
  }

  packTimestamp(value: number): void {
    this.helper.packTimestamp(value)
  }

  packExtensionTypeHeader(extType: number, payloadLen: number): void {
    this.helper.packExtensionTypeHeader(extType, payloadLen)
  }

  writePayload(value: Array<number>): void {
    this.helper.writePayload(value)
  }

  packJson(value: string): void {
    this.helper.packJson(value)
  }

  packNull(): void {
    this.helper.packNull()
  }

  toByteArray(): Array<number> {
     return this.helper.toByteArray();
  }


  constructor (){}
}

export class MessageUnPacker {
  helper: MessageUnPackerTs

  unpackBool(): boolean {
    return this.helper.unpackBool();
  }

  unpackInt8(): number {
    return this.helper.unpackInt8()
  }
  unpackInt16(): number {
    return this.helper.unpackInt16()
  }

  unpackInt32(): number {
    return this.helper.unpackInt32()
  }

  unpackInt64(): number {
    return this.helper.unpackInt64()
  }

  unpackString(): string {
    return this.helper.unpackString()
  }

  unpackFloat64(): number {
    return this.helper.unpackFloat64()
  }

  unpackNull(): void {
    return this.helper.unpackNull()
  }

  unpackArray(): Array<number> {
    return this.helper.unpackArray()
  }

  unpackMapHeader(): number {
    return this.helper.unpackMapHeader()
  }

  unpackArrayHeader(): number {
    return this.helper.unpackArrayHeader()
  }

  unpackTimestamp(): number {
    return this.helper.unpackTimestamp()
  }

  unpackExtensionTypeHeader(): Array<number> {
    return this.helper.unpackExtensionTypeHeader()
  }

  readPayload(value: number): Array<number> {
    return this.helper.readPayload(value)
  }

  constructor (value: Array<number>){
    this.helper = new MessageUnPackerTs(value)
  }
}