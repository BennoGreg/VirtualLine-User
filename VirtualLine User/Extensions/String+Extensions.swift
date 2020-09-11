//
//  String+Extensions.swift
//  VirtualLine User
//
//  Created by Niklas Wagner on 10.09.20.
//  Copyright © 2020 Benedikt. All rights reserved.
//

extension String {
    
    public func removingOccurences(of strings: [String]) -> String {
           var newString = self
           for string in strings {
               newString = newString.replacingOccurrences(of: string, with: "")
           }
           return newString
       }
}
