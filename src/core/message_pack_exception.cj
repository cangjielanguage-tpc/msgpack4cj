/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core

import std.math.numeric.BigInt
import std.binary.BigEndianOrder
import std.collection.ArrayList
import std.core.Exception

public open class MessagePackException <: Exception {

    public init() {
        super()
    }

    public init(messages: String) {
        super(messages)
    }

    public open func toString(): String {
        return "MessagePackException: ${message}"
    }

}


public open class MessageTypeException<: MessagePackException {

    public init() {
        super()
    }

    public init(message: String) {
        super(message)
    }

    public open func toString(): String {
        return "MessageTypeException: ${message}"
    }

}



public open class MessageIntegerOverflowException<: MessageTypeException {

    private var bigInteger: BigInt

    public init(bigInteger: BigInt) {
        super()
        this.bigInteger = bigInteger
    }

    public func getBigInteger(): BigInt {
        return bigInteger
    }

    public func toString(): String {
        return "MessageIntegerOverflowException: ${bigInteger}"
    }
}

public open class MessageSizeException<: MessagePackException {

    private var size: Int64 = 0

    public init(size: Int64) {
        super()
        this.size = size
    }

    public init(message: String, size: Int64) {
        super(message)
        this.size = size
    }

    public func getSize(): Int64 {
        return size
    }

    public func toString(): String {
        return "MessageSizeException: ${message}"
    }

}

public open class MessageFormatException<: MessagePackException {

    public init(message: String) {
        super(message)
    }

    public func toString(): String {
        return "MessageFormatException: ${message}"
    }

}