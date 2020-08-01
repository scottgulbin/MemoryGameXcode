//
//  Array+Only.swift
//  Memorize
//
//  Created by Scott Gulbin on 7/10/20.
//  Copyright © 2020 Scott Gulbin. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
