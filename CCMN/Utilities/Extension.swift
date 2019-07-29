//
//  Extension.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 7/29/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation

extension String {

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
