//
//  Item.swift
//  LearnTrack
//
//  Created by Utilisateur invité on 04/12/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
