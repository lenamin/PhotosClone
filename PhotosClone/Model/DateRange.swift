//
//  DateRange.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/10.
//

import Foundation

enum DateGroupRange {
    case day(Date)
    case month(Date)
    case year(Date)
    case range(Date, Date)
}

enum DateMode {
    case day(Date)
    case month(Date)
    case year(Date)
}
