// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.time.MonoTime
import std.unittest.*
import std.unittest.testmacro.*
import serialization.serialization.{DataModel, DataModelStruct, field, Serializable}
import msgpack4cj.core.*
import msgpack4cj.serialization.*

import std.binary.BigEndianOrder
import std.collection.ArrayList
import std.time.*


@Test
public class MessageTestImmutableE {
    @TestCase
    @OverflowWrapping
    public func testImmutableExtensionValue_01(): Unit {
        var extensionValue: ImmutableExtensionValueImpl = (ValueFactory.newExtension(2u8, [11u8, 121u8]) as ImmutableExtensionValueImpl).getOrThrow()
        var packer = MessagePack.newDefaultBufferPacker()
        extensionValue.writeTo(packer)
        var unpacker = MessagePack.newDefaultUnpacker(packer.toByteArray())
        let header: ExtensionTypeHeader = unpacker.unpackExtensionTypeHeader()
        @Assert(header.getLength(), 2)
        @Assert(header.getType(), 2)
        var s = unpacker.readPayload(2)
        @Assert(s.toString(),"[11, 121]")
    }

}