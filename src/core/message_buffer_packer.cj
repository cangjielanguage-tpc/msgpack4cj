/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

package msgpack4cj.core


 public class MessageBufferPacker <: MessagePacker {

    private let buffer: ByteArrayStream

    protected init(buffer: ByteArrayStream, config: PackerConfig) {
        super(buffer, config)
        this.buffer = buffer
    }

    public func toByteArray(): Array<Byte> {
        return buffer.readToEnd()
    }

 }