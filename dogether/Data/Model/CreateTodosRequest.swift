//
//  CreateTodosRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

// TODO: 추후 수정
struct CreateTodosRequest: Todos, Encodable {
    let todos: [String] = ["프로그래머스 코테 두 문제 풀기", "저녁 운동 조지기", "감정 회고록 작성하기"]
}
