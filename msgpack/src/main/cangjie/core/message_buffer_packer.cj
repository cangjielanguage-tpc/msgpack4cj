/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

package msgpack.core

import std.io.ByteBuffer
import std.io.readToEnd

 public class MessageBufferPacker <: MessagePacker {

    private let buffer: ByteBuffer

    protected init(buffer: ByteBuffer, config: PackerConfig) {
        super(buffer, config)
        this.buffer = buffer
    }

    public func toByteArray(): Array<Byte> {
        return readToEnd(buffer)
    }

 }