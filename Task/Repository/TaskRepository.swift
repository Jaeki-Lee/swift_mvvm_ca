//
//  TaskRepository.swift
//  Task
//
//  Created by trost.jk on 2022/09/16.
//

import Foundation
import RxSwift
import Moya

protocol TaskRepositoryProtocol {
    func getRecruitItems() -> Single<RecruitItems>
    func getCellItems() -> Single<CellItems>
}

class TaskRepository: TaskRepositoryProtocol {
    func getRecruitItems() -> Single<RecruitItems> {
        return TaskAPI.recruitItems
            .request()
            .map {
                let jsonString = try $0.mapString()
                
                guard let value = jsonString.data(using: .utf8) else { return $0 }
                
                let newResponse = Response(
                    statusCode: $0.statusCode,
                    data: value,
                    request: $0.request,
                    response: $0.response
                )
                
                return newResponse
            }
            .map(RecruitItems.self, using: TaskAPI.jsonDecoder)
    }

    func getCellItems() -> Single<CellItems> {
        return TaskAPI.cellItems
            .request()
            .map {
                let jsonString = try $0.mapString()
                
                guard let value = jsonString.data(using: .utf8) else { return $0 }
                
                let newResponse = Response(
                    statusCode: $0.statusCode,
                    data: value,
                    request: $0.request,
                    response: $0.response
                )
                
                return newResponse
            }
            .map(CellItems.self, using: TaskAPI.jsonDecoder)
    }
}
