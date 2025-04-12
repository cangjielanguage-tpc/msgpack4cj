
/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core

import std.math.numeric.BigInt
import std.io.ByteBuffer
import std.io.readToEnd
import std.binary.BigEndianOrder
import std.collection.ArrayList
import std.core.Exception

public open class UnsupportedOperationException <: Exception {
    private var messages: String = ""

    public init() {
        super()
    }

    public init(messages: String) {
        super(messages)
        this.messages = messages
    }
    public open func getMessage(): String {
        return messages
    }
    public override func toString(): String {
        return "UnsupportedOperationException: ${messages}"
    }
}


public open class MessagePackException <: UnsupportedOperationException {
    public static let UNREACHABLE: IllegalStateException = IllegalStateException("Cannot reach here")
    public init() {
    
        super()
    }

    public init(messages: String)
    {
        super(messages)
    }

    public static func UNSUPPORTED(operationName: String): UnsupportedException
    {
        return UnsupportedException(operationName)
    }
}


public open class MessageTypeException<: MessagePackException
{
    public init()
    {
        super()
    }

    public init(message: String)
    {
        super(message)
    }
}



public open class MessageIntegerOverflowException<: MessageTypeException
{
    private var bigInteger: BigInt

    public init(bigInteger: BigInt)
    {
        super()
        this.bigInteger = bigInteger
    }

    public init(messages: String, bigInteger: BigInt)
    {   
        super(messages)
        this.bigInteger = bigInteger
    }

    public func getBigInteger(): BigInt {
        return bigInteger
    }

    public override func getMessage(): String {
        return bigInteger.toString()
    }
}

public open class MessageSizeException<: MessagePackException
{
    private var size: Int64 = 0

    public init(size: Int64)
    {
        super()
        this.size = size
    }

    public init(message: String, size: Int64)
    {
        super(message)
        this.size = size
    }

    public func getSize(): Int64 {
        return size
    }
}

public open class MessageFormatException<: MessagePackException
{

    public init(message: String)
    {
        super(message)
    }

}