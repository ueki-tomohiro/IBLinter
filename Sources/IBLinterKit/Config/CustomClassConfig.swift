//
//  CustomClassConfig.swift
//  IBLinterKit
//
//  Created by ueki-tomohiro on 2020/5/17.
//

import Foundation
import Yams

public struct CustomClassConfig: Codable {
    public let elementClass: String
    public let suffix: String
    public let strict: Bool

    enum CodingKeys: String, CodingKey {
        case elementClass = "element_class"
        case suffix = "suffix"
        case strict = "strict"
    }

    init(elementClass: String, suffix: String, strict: Bool) {
        self.elementClass = elementClass
        self.suffix = suffix
        self.strict = strict
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        elementClass = try container.decode(String.self, forKey: .elementClass)
        suffix = try container.decode(String.self, forKey: .suffix)
        strict = try container.decodeIfPresent(Bool.self, forKey: .strict) ?? false
    }
}