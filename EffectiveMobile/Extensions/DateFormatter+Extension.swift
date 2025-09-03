//
//  DateFormatter+Extension.swift
//  EffectiveMobile
//
//  Created by Alexander Ognerubov on 03.09.2025.
//

import Foundation

extension DateFormatter {
   static let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }()
}
