//
//  DateFormatter+Extension.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/13.
//

import Foundation

extension DateFormatter {
    /// DateMode 타입에 따른 DateFormatter 설정
    /// - Parameter dateMode: enum (.day, .month, .year)
    /// - Returns: 각 모드에 따른 날짜 출력 (헤더 등에서 사용) 
    static func formatter(for dateMode: DateMode) -> DateFormatter {
        let dateFormatter = DateFormatter()
        switch dateMode {
        case .day:
            dateFormatter.dateFormat = "yyyy년 M월 d일"
        case .month:
            dateFormatter.dateFormat = "yyyy년 M월"
        case .year:
            dateFormatter.dateFormat = "yyyy년"
        }
        return dateFormatter
    }
    
    func formattedDateInKorean(from date: Date?) -> String {
        guard let date = date else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
}
