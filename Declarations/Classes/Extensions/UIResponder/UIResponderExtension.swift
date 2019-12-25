//
//  UIResponderExtension.swift
//  Declarations
//
//  Created by Yaroslava Hlibochko on 24.12.2019.
//  Copyright © 2019 Yaroslava Hlibochko. All rights reserved.
//

import Foundation
import UIKit

extension UIResponder {
    func next<U: UIResponder>(of type: U.Type = U.self) -> U? {
        return self.next.flatMap({ $0 as? U ?? $0.next() })
    }
}
