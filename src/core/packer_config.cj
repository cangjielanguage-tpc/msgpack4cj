/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core

public class PackerConfig <: Equal<PackerConfig> & Hashable {

    private var bufferSize: Int64 = 8192

    private var stringSizeLimit: Int64 = Int64(Int32.Max)

    private var binarySizeLimit: Int64 = Int64(Int32.Max)

    public init() {}

    private init(from: PackerConfig) {
        this.bufferSize = from.bufferSize
        this.stringSizeLimit = from.stringSizeLimit
        this.binarySizeLimit = from.binarySizeLimit
    }

    public func clone(): PackerConfig {
        return PackerConfig(this)
    }

    public func getBufferSize(): Int64 {
        return this.bufferSize
    }

    public func getBinarySizeLimit(): Int64 {
        return this.binarySizeLimit
    }

    public func getStringSizeLimit(): Int64 {
        return this.stringSizeLimit
    }

    public func withBufferSize(size: Int64): PackerConfig {
        let new = PackerConfig(this)
        new.bufferSize = size
        return new
    }

    public func withBinarySizeLimit(limit: Int64): PackerConfig {
        let new = PackerConfig(this)
        new.binarySizeLimit = limit
        return new
    }

    public func withStringSizeLimit(limit: Int64): PackerConfig {
        let new = PackerConfig(this)
        new.stringSizeLimit = limit
        return new
    }

    public operator func == (other: PackerConfig): Bool {
        this.binarySizeLimit == other.binarySizeLimit &&
        this.stringSizeLimit == other.stringSizeLimit  &&
        this.bufferSize == other.bufferSize
    }

    public func hashCode(): Int64 {
        var result = stringSizeLimit.hashCode()
        result = 31 * result + binarySizeLimit.hashCode()
        result = 31 * result + bufferSize.hashCode()
        return result
    }

}

