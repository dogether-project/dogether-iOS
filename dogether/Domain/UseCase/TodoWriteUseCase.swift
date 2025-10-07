//
//  TodoWriteUseCase.swift
//  dogether
//
//  Created by seungyooooong on 10/4/25.
//

import Foundation

final class TodoWriteUseCase {
    func prefixTodo(todo: String?, todoMaxLength: Int) -> String {
        return String((todo ?? "").prefix(todoMaxLength))
    }
}
