/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
import { MessagePacker, MessageUnPacker, DataModel } from '@cangjie-tpc/msgpack';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { util } from '@kit.ArkTS';

export function pack_array_header(): string {
  try {
    let c = new MessagePacker()
    c.packArrayHeader(11244)
    c.packArrayHeader(24984973)
    c.packArrayHeader(32)
    c.packArrayHeader(125)
    c.packArrayHeader(0)

    return c.toByteArray().toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function unpack_array_header(): string {
  try {
    let value = [220,43,236,221,1,125,61,141,220,0,32,220,0,125,144]
    let c = new MessageUnPacker(value)
    let a1 = c.unpackArrayHeader()
    let a2 = c.unpackArrayHeader()
    let a3 = c.unpackArrayHeader()
    let a4 = c.unpackArrayHeader()
    let a5 = c.unpackArrayHeader()
    return a1 + ', ' + a2 + ', ' + a3 + ', ' + a4 + ', ' + a5
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function pack_array(): string {
  try {
    let c = new MessagePacker()
    c.packArray([])

    return c.toByteArray().toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function unpack_array(): string {
  try {
    let value = [196,0]
    let c = new MessageUnPacker(value)
    let a1 = c.unpackArray()
    return a1.toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function pack_array_2(): string {
  try {
    let c = new MessagePacker()
    let str  = 'testBinary_02'
    let arr: Array<number> = new Array<number>()
    for (let i = 0; i < str.length; i++) {
      arr.push(str.charCodeAt(i));
    }
    c.packArray(arr)

    return c.toByteArray().toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function unpack_array_2(): string {
  try {
    let value = [196,13,116,101,115,116,66,105,110,97,114,121,95,48,50]
    let c = new MessageUnPacker(value)
    let byteArray = c.unpackArray()

     let decoder = util.TextDecoder.create("utf-8", { ignoreBOM: true })
    let resultString = decoder.decode(new Uint8Array(byteArray))
    return resultString
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function pack_extension(type: number, data: Array<number>): string {
  try {
    let c = new MessagePacker()
    c.packExtensionTypeHeader(type, data.length)
    c.writePayload(data)

    return c.toByteArray().toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function unpack_extension(value: Array<number>): string {
  try {
    let c = new MessageUnPacker(value)
    let a1 = c.unpackExtensionTypeHeader()
    let a2 = c.readPayload(a1[1])
    return a1[0] + ' ' + a1[1] + ' ' + a2.toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function pack_map_header(data: Array<number>): string {
  try {
    let c = new MessagePacker()
    c.packMapHeader(data[0])
    c.packMapHeader(data[1])
    c.packMapHeader(data[2])
    c.packMapHeader(data[3])
    c.packMapHeader(data[4])

    return c.toByteArray().toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function unpack_map_header(value: Array<number>): string {
  try {
    let c = new MessageUnPacker(value)
    let a1 = c.unpackMapHeader()
    let a2 = c.unpackMapHeader()
    let a3 = c.unpackMapHeader()
    let a4 = c.unpackMapHeader()
    let a5 = c.unpackMapHeader()
    return a1 + ', ' + a2 + ', ' + a3 + ', ' + a4 + ', ' + a5
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function pack_string(data: string): string {
  try {
    let c = new MessagePacker()
    c.packString(data)

    return c.toByteArray().toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function unpack_string(value: Array<number>): string {
  try {
    let c = new MessageUnPacker(value)
    let a1 = c.unpackString()
    return a1
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}
export function pack_json(data: string): string {
  try {
    let dataModel = new DataModel()
    let bytes = dataModel.packJson(data)
    hilog.error(0, 'ss', `${bytes.length}`)
    return bytes.toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function big_pack_json(data: string): Array<number> {
  try {
    let dataModel = new DataModel()
    let bytes = dataModel.packJson(data)
    hilog.error(0, 'ss', `${bytes.length}`)
    return bytes
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return []
  }
}

export function unpack_json(value: Array<number>): string {
  try {
    let dataModel = new DataModel()

    return dataModel.unpackJson(value)
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}