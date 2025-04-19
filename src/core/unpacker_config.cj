/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core

public class UnpackerConfig <: Equal<UnpackerConfig> & Hashable {

    private var stringSizeLimit: Int64 = Int64(Int32.Max)

    private var binarySizeLimit: Int64 = Int64(Int32.Max)

    private var allowReadingStringAsBinary: Bool = true

    private var allowReadingBinaryAsString: Bool = true

    public init() {}

    private init(from: UnpackerConfig) {
        this.stringSizeLimit = from.stringSizeLimit
        this.binarySizeLimit = from.binarySizeLimit
        this.allowReadingBinaryAsString = from.allowReadingBinaryAsString
        this.allowReadingStringAsBinary = from.allowReadingStringAsBinary
    }

    public func getBinarySizeLimit(): Int64 {
        return this.binarySizeLimit
    }

    public func getStringSizeLimit(): Int64 {
        return this.stringSizeLimit
    }

    public func getAllowReadingBinaryAsString(): Bool {
        return this.allowReadingBinaryAsString
    }

    public func getAllowReadingStringAsBinary(): Bool {
        return this.allowReadingStringAsBinary
    }

    public func withBinarySizeLimit(limit: Int64): UnpackerConfig {
        let new = UnpackerConfig(this)
        new.binarySizeLimit = limit
        return this
    }

    public func withStringSizeLimit(limit: Int64): UnpackerConfig {
        let new = UnpackerConfig(this)
        new.stringSizeLimit = limit
        return new
    }

    public func withAllowReadingBinaryAsString(enable: Bool): UnpackerConfig {
        let new = UnpackerConfig(this)
        new.allowReadingBinaryAsString = enable
        return new
    }

    public func withAllowReadingStringAsBinary(enable: Bool): UnpackerConfig {
        let new = UnpackerConfig(this)
        new.allowReadingStringAsBinary = enable
        return new
    }

    public operator func == (other: UnpackerConfig): Bool {
        this.allowReadingBinaryAsString == other.allowReadingBinaryAsString &&
        this.allowReadingStringAsBinary == other.allowReadingStringAsBinary && 
        this.binarySizeLimit == other.binarySizeLimit &&
        this.stringSizeLimit == other.stringSizeLimit 
    }

    public func hashCode(): Int {
        var result = stringSizeLimit.hashCode()
        result = 31 * result + binarySizeLimit.hashCode()
        result = 31 * result + allowReadingBinaryAsString.hashCode()
        result = 31 * result + allowReadingBinaryAsString.hashCode()
        return result
    }

}