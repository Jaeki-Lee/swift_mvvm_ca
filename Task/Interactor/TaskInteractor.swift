//
//  TaskInteractor.swift
//  Task
//
//  Created by trost.jk on 2022/09/17.
//

import Foundation
import RxSwift
import RxCocoa

protocol TaskInteractorProtocol {
    func getRecruitItems() -> Single<RecruitItems>
    func getCellItems() -> Single<CellItems>
}

class TaskInteractor: TaskInteractorProtocol {
    
    let taskRepository: TaskRepositoryProtocol?
    
    init(taskRepository: TaskRepositoryProtocol) {
        self.taskRepository = taskRepository
    }
    
    func getRecruitItems() -> Single<RecruitItems> {
        return self.taskRepository!.getRecruitItems()
    }
    
    func getCellItems() -> Single<CellItems> {
        return self.taskRepository!.getCellItems()
    }
}
