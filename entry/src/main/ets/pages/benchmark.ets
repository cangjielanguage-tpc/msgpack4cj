/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
import { MessagePacker, MessageUnPacker } from '@cangjie-tpc/msgpack';
import { hilog } from '@kit.PerformanceAnalysisKit';

// 与纯仓颉基准 benchmark/test_pack_unpack.cj 中的 pack() 保持一致；
// 通过 reset 复用互操作包装对象，避免循环内新建跨语言包装器导致 OOM
function doPackWith(packer: MessagePacker): Array<number> {
  packer.reset()
  packer.packMapHeader(3)
  packer.packString("name")
  packer.packString("yesokim")
  packer.packString("age")
  packer.packInt64(22)
  packer.packString("hobby")
  packer.packArrayHeader(1)
  packer.packString("code")
  return packer.toByteArray()
}

// 与纯仓颉基准 benchmark/test_pack_unpack.cj 中的 unpack() 保持一致
function doUnpackWith(unpacker: MessageUnPacker, data: Array<number>): void {
  unpacker.reset(data)
  let mapSize = unpacker.unpackMapHeader()
  let key1 = unpacker.unpackString()
  let name = unpacker.unpackString()
  let key2 = unpacker.unpackString()
  let age = unpacker.unpackInt64()
  let key3 = unpacker.unpackString()
  let arraySize = unpacker.unpackArrayHeader()
  let hobby = unpacker.unpackString()
}

export async function benchmarkPack(count: number): Promise<string> {
  try {
    let packer = new MessagePacker()
    let startTime = Date.now()
    for (let i = 0; i < count; i++) {
      doPackWith(packer)
    }
    let duration = Date.now() - startTime
    let nsPerOp = duration * 1000000 / count
    let result = `TestSuite_pack_${count} : ${Math.round(nsPerOp)} ns/op (总耗时 ${duration}ms)`
    hilog.info(0, 'msgpack_benchmark', result)
    return result
  } catch (e) {
    let result = `pack_${count} 基准测试失败: ${e}`
    hilog.error(0, 'msgpack_benchmark', result)
    return result
  }
}

export async function benchmarkUnpack(count: number): Promise<string> {
  try {
    await new Promise<void>((resolve) => {
      setTimeout(resolve, 0)
    })
    let packer = new MessagePacker()
    let data = doPackWith(packer)
    let unpacker = new MessageUnPacker(data)
    let startTime = Date.now()
    for (let i = 0; i < count; i++) {
      doUnpackWith(unpacker, data)
    }
    let duration = Date.now() - startTime
    let nsPerOp = duration * 1000000 / count
    let result = `TestSuite_unpack_${count} : ${Math.round(nsPerOp)} ns/op (总耗时 ${duration}ms)`
    hilog.info(0, 'msgpack_benchmark', result)
    return result
  } catch (e) {
    let result = `unpack_${count} 基准测试失败: ${e}`
    hilog.error(0, 'msgpack_benchmark', result)
    return result
  }
}
