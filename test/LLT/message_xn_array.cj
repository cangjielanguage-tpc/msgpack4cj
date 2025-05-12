// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import encoding.json.{ToJson, JsonValue}
import encoding.hex.toHexString
import serialization.serialization.{Serializable, DataModel, DataModelStruct, field}
import std.time.MonoTime
import msgpack4cj.core.*
import msgpack4cj.serialization.*
import std.collection.*

@Test
public class messageArray {

    @TestCase
    public func test(): Unit {
        simpleTest()

    }

    func simpleTest() {
        let array = [1, 2, 3, 4]
        let size = array.size
        let packer = MessagePack.newDefaultBufferPacker()
        packer.packArrayHeader(size)

        for(i in 0..size) {
            packer.packInt64(array[i])
        }

        let data = packer.toByteArray()
        let unpacker = MessagePack.newDefaultUnpacker(data)
        var array2 = Array<Int64>(4, item: 0)

         var arraySize = unpacker.unpackArrayHeader()
         for (j in 0..arraySize) {
            var v: Int64 = unpacker.unpackInt64()
            array2[j] = v
        }
        @Assert(array2.toString(), "[1, 2, 3, 4]")

    }
}