//
//  CertificationViewModel.swift
//  dogether
//
//  Created by seungyooooong on 10/18/25.
//

import RxRelay

final class CertificationViewModel {
    private let challengeGroupsUseCase: ChallengeGroupsUseCase
    private let todosUseCase: TodosUseCase
    
    private(set) var preCertificationViewDatas = BehaviorRelay<PreCertificationViewDatas>(
        value: PreCertificationViewDatas()
    )
    private(set) var certificationViewDatas = BehaviorRelay<CertificationViewDatas>(value: CertificationViewDatas())
    
    init() {
        let challengeGroupsRepository = DIManager.shared.getChallengeGroupsRepository()
        let todosRepository = DIManager.shared.getTodosRepository()
        
        self.challengeGroupsUseCase = ChallengeGroupsUseCase(repository: challengeGroupsRepository)
        self.todosUseCase = TodosUseCase(repository: todosRepository)
    }
}

extension CertificationViewModel {
    func loadCertificationView() async throws {
        let datas = preCertificationViewDatas.value
        // MARK: from Main
        if let date = datas.date, let groupId = datas.groupId, let todoId = datas.todoId, let filter = datas.filter {
            let todos = try await challengeGroupsUseCase.getMyTodos(groupId: groupId, date: date).filter {
                filter == .all || filter == FilterTypes(status: $0.status.rawValue)
            }
            
            certificationViewDatas.update {
                $0.title = datas.title
                $0.index = todos.firstIndex { $0.id == todoId } ?? 0
                $0.todos = todos
            }
        }
        
        // MARK: from Ranking
        if let groupId = datas.groupId, let memberId = datas.memberId {
            let (index, todos) = try await getMemberTodos(groupId: groupId, memberId: memberId)
            
            certificationViewDatas.update {
                $0.title = datas.title
                $0.index = index
                $0.todos = todos
            }
        }
        
        // MARK: from CertificationList
        if let todoId = datas.todoId, let sortOption = datas.sortOption, let filter = datas.filter {
            // FIXME: 추가된 API 적용
            print("todo Id \(todoId), sortOption \(sortOption) filter \(filter)")
        }
    }
    
    func getMemberTodos(groupId: Int, memberId: Int) async throws -> (Int, [TodoEntity]) {
        try await challengeGroupsUseCase.getMemberTodos(groupId: groupId, memberId: memberId)
    }
    
    func setIndex(index: Int) async throws {
        if certificationViewDatas.value.rankingEntity == nil {
            certificationViewDatas.update { $0.index = index }
        } else {
            // MARK: 이전에 보고 있던 thumbnailStatus를 수정하고 이동한 todo의 read API를 호출
            certificationViewDatas.update { $0.todos[certificationViewDatas.value.index].thumbnailStatus = .done }
            certificationViewDatas.update { $0.index = index }
            try await readTodo(index: index)
        }
    }
    
    func readTodo(index: Int? = nil) async throws {
        if certificationViewDatas.value.rankingEntity == nil { return }
        let index = index ?? certificationViewDatas.value.index
        guard let todo = certificationViewDatas.value.todos[safe: index] else { return }
        try await challengeGroupsUseCase.readTodo(todo: todo)
    }
    
    func remindTodo(remindType: RemindTypes, todoId: Int) async throws {
        try await todosUseCase.remindTodo(remindType: remindType, todoId: todoId)
    }
}
