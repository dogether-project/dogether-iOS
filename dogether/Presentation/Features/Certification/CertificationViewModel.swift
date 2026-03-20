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
    private let userUseCase: UserUseCase
    
    private(set) var preCertificationViewDatas = BehaviorRelay<PreCertificationViewDatas?>(value: nil)
    private(set) var certificationViewDatas = BehaviorRelay<CertificationViewDatas>(value: CertificationViewDatas())
    
    init() {
        let challengeGroupsRepository = DIManager.shared.getChallengeGroupsRepository()
        let todosRepository = DIManager.shared.getTodosRepository()
        let userRepository = DIManager.shared.getUserRepository()
        
        self.challengeGroupsUseCase = ChallengeGroupsUseCase(repository: challengeGroupsRepository)
        self.todosUseCase = TodosUseCase(repository: todosRepository)
        self.userUseCase = UserUseCase(repository: userRepository)
    }
}

extension CertificationViewModel {
    func loadCertificationView() async throws {
        guard let datas = preCertificationViewDatas.value else { return }

        switch datas {
        case .main(let title, let date, let groupId, let todoId, let filter):
            let todos = try await getMyTodos(groupId: groupId, date: date, filter: filter)
            certificationViewDatas.update {
                $0.title = title
                $0.index = todos.firstIndex { $0.id == todoId } ?? 0
                $0.todos = todos
            }

        case .ranking(let title, let groupId, let memberId):
            let (index, isMine, todos) = try await getMemberTodos(groupId: groupId, memberId: memberId)
            certificationViewDatas.update {
                $0.title = title
                $0.isMine = isMine
                $0.index = index
                $0.todos = todos
            }

        case .certificationList(let title, let todoId, let sortOption, let filter):
            let todos = try await getMyCertifications(todoId: todoId, sortOption: sortOption, filter: filter)
            certificationViewDatas.update {
                $0.title = title
                $0.index = todos.firstIndex { $0.id == todoId } ?? 0
                $0.todos = todos
            }
        }
    }
    
    func getMyTodos(groupId: Int, date: String, filter: FilterTypes) async throws -> [TodoEntity] {
        try await challengeGroupsUseCase.getMyTodos(groupId: groupId, date: date).filter {
            filter == .all || filter == FilterTypes(status: $0.status.rawValue)
        }
    }
    
    func getMemberTodos(groupId: Int, memberId: Int) async throws -> (Int, Bool, [TodoEntity]) {
        try await challengeGroupsUseCase.getMemberTodos(groupId: groupId, memberId: memberId)
    }
    
    func getMyCertifications(todoId: Int, sortOption: SortOptions, filter: FilterTypes) async throws -> [TodoEntity] {
        try await userUseCase.getMyCertifications(todoId: todoId, sortOption: sortOption).filter {
            filter == .all || filter == FilterTypes(status: $0.status.rawValue)
        }
    }
    
    func setIndex(index: Int) async throws {
        if certificationViewDatas.value.isMine == nil {
            certificationViewDatas.update { $0.index = index }
        } else {
            // MARK: 이전에 보고 있던 thumbnailStatus를 수정하고 이동한 todo의 read API를 호출
            certificationViewDatas.update { $0.todos[certificationViewDatas.value.index].thumbnailStatus = .done }
            certificationViewDatas.update { $0.index = index }
            try await readTodo(index: index)
        }
    }
    
    func readTodo(index: Int? = nil) async throws {
        let index = index ?? certificationViewDatas.value.index
        guard let todo = certificationViewDatas.value.todos[safe: index],
              case .ranking = preCertificationViewDatas.value else { return }
        try await challengeGroupsUseCase.readTodo(todo: todo)
    }
    
    func remindTodo(remindType: RemindTypes, todoId: Int) async throws {
        try await todosUseCase.remindTodo(remindType: remindType, todoId: todoId)
    }
    
    func updateButtonStatus(remindType: RemindTypes, todoId: Int) {
        guard let index = certificationViewDatas.value.todos.firstIndex(where: { $0.id == todoId }) else { return }
        switch remindType {
        case .certification:
            certificationViewDatas.update { $0.todos[index].canRemindCertification = false }
        case .review:
            certificationViewDatas.update { $0.todos[index].canRemindReview = false }
        }
    }
}
