//
//  GetReviewsResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/5/25.
//

import Foundation

struct GetReviewsResponse: Decodable {
    let dailyTodoCertifications: [ReviewModel]
}
