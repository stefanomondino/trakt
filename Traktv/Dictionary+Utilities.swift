//
//  Dictionary+Utilities.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation

public extension Dictionary {
    public static func +(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach{ result[$0] = $1 }
        return result
    }
    public static func +=(lhs: inout [Key: Value], rhs: [Key: Value]) { rhs.forEach({ lhs[$0] = $1}) }
}
