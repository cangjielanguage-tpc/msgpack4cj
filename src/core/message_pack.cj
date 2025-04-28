/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

package msgpack4cj.core

import std.io.ByteBuffer
import std.io.OutputStream
import std.io.InputStream

public class MessagePack {

    private static let DEFAULT_PACKER_CONFIG = PackerConfig()

    private static let DEFAULT_UNPACKER_CONFIG = UnpackerConfig()

    public static func newDefaultPacker(output: OutputStream): MessagePacker {
        return newPacker(output, DEFAULT_PACKER_CONFIG)
    }

    public static func newDefaultBufferPacker(): MessageBufferPacker {
        return newBufferPacker(DEFAULT_PACKER_CONFIG)
    }

    public static func newDefaultUnpacker(input: InputStream): MessageUnpacker {
        return newUnpacker(input, DEFAULT_UNPACKER_CONFIG)
    }

    public static func newDefaultUnpacker(content: Array<Byte>): MessageUnpacker {
        return newUnpacker(content, DEFAULT_UNPACKER_CONFIG)
    }

    public static func newPacker(output: OutputStream, config: PackerConfig): MessagePacker {
        return MessagePacker(output, config)
    }

    public static func newBufferPacker(config: PackerConfig): MessageBufferPacker {
        return MessageBufferPacker(ByteBuffer(config.getBufferSize()), config)
    }

    public static func newUnpacker(input: InputStream, config: UnpackerConfig): MessageUnpacker {
        return MessageUnpacker(input, config)
    }

    public static func newUnpacker(content: Array<Byte>, config: UnpackerConfig): MessageUnpacker {
        return MessageUnpacker(ByteBuffer(content), config)
    }

}