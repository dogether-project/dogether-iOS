//
//  CertificationViewModel.swift
//  dogether
//
//  Created by seungyooooong on 10/18/25.
//

import RxRelay

final class CertificationViewModel {
    
    private(set) var certificationViewDatas = BehaviorRelay<CertificationViewDatas>(value: CertificationViewDatas())
    
    // MARK: - Computed
    var currentTodo: TodoEntity { certificationViewDatas.value.todos[certificationViewDatas.value.index] }
}
