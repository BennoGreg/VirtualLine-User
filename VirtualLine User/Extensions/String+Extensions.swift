//
//  String+Extensions.swift
//  VirtualLine User
//
//  Created by Niklas Wagner on 10.09.20.
//  Copyright © 2020 Benedikt. All rights reserved.
//
import UIKit

extension String {
    
    public func removingOccurences(of strings: [String]) -> String {
           var newString = self
           for string in strings {
               newString = newString.replacingOccurrences(of: string, with: "")
           }
           return newString
       }
        public init(deviceToken: Data) {
            self = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
        }
    
}
