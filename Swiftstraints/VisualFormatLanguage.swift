//
//  LayoutConstraints.swift
//  Swiftstraints
//
//  Created by Bradley Hilton on 5/12/15.
//  Copyright (c) 2015 Skyvive. All rights reserved.
//

import Foundation

func + <Key, Value>(var lh: [Key : Value], rh: [Key : Value]) -> [Key : Value] {
    for (key, value) in rh {
        lh[key] = value
    }
    return lh
}

public struct VisualFormatLanguage : StringInterpolationConvertible {
    
    let format: String
    var metrics = [String : NSNumber]()
    var views = [String : UIView]()
    
    public init(stringInterpolation strings: VisualFormatLanguage...) {
        format = strings.reduce("") { return $0.0 + $0.1.format }
        views = strings.reduce([:]) { return $0.0 + $0.1.views }
    }
    
    public init<T>(stringInterpolationSegment expr: T) {
        if let view = expr as? UIView {
            format = "A\(unsafeAddressOf(view).hashValue)B"
            views[format] = view
        } else if let number = expr as? NSNumber {
            format = "A\(unsafeAddressOf(number).hashValue)B"
            metrics[format] = number
        } else {
            format = "\(expr)"
        }
    }
    
    /// Returns layout constraints with options
    public func constraints(options: NSLayoutFormatOptions) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat(format, options: [], metrics: metrics, views: views)
    }
    
    /// Returns layout constraints
    public var constraints: [NSLayoutConstraint] {
        return constraints([])
    }
    
}

public typealias NSLayoutConstraints = [NSLayoutConstraint]

extension Array where Element : NSLayoutConstraint {
    
    /// Create a list of constraints using a string interpolated with nested views and metrics
    /// You can optionally include NSLayoutFormatOptions as the second parameter
    public init(_ visualFormatLanguage: VisualFormatLanguage, options: NSLayoutFormatOptions = []) {
        if let constraints = visualFormatLanguage.constraints(options) as? [Element] {
            self = constraints
        } else {
            self = []
        }
    }
    
}
