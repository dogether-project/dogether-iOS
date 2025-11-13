//
//  TodoWriteUseCase.swift
//  dogether
//
//  Created by seungyooooong on 10/4/25.
//

import Foundation

final class TodoWriteUseCase {
    func prefixTodo(todo: String?, maxLength: Int) -> String {
        return String((todo ?? "").prefix(maxLength))
    }
}
