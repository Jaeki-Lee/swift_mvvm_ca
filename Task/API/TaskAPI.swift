//
//  TaskAPI.swift
//  Task
//
//  Created by trost.jk on 2022/09/16.
//

import Moya
import RxSwift

enum TaskAPI {
    case recruitItems
    case cellItems
}

extension TaskAPI {
    static let moya = MoyaWrapper.provider
    
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
    var baseURL: URL {
        return URL(string: "https://jpassets.jobplanet.co.kr/mobile-config")!
    }
    
    var path: String {
        switch self {
        case .recruitItems: return "/test_data_recruit_items.json"
        case .cellItems: return "/test_data_cell_items.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .recruitItems:
            return .get
        case .cellItems:
            return .get
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Api-Configure": "Production",
        ]
    }
    
    var task: Task {
        switch self {
        case .recruitItems:
            return .requestPlain
        case .cellItems:
            return .requestPlain
        }
    }
    
    struct Wrapper: TargetType {
        let base: TaskAPI
        
        var baseURL: URL { self.base.baseURL }
        var path: String { self.base.path }
        var method: Moya.Method { self.base.method }
        var task: Task { self.base.task }
        var headers: [String: String]? { self.base.headers }
    }
    
    private enum MoyaWrapper {
        
        static var provider: MoyaProvider<TaskAPI.Wrapper> {
            
            let loggerPlugin = NetworkLoggerPlugin()
                        
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            configuration.urlCredentialStorage = nil
            
            let session = Session(configuration: configuration)
            
            return MoyaProvider<TaskAPI.Wrapper>(
                endpointClosure: { targetType in
                    MoyaProvider.defaultEndpointMapping(for: targetType)
                },
                session: session,
                plugins: [loggerPlugin]
                )
        }
    }

}

extension TaskAPI {
    func request() -> Single<Response> {
        let endPoint = TaskAPI.Wrapper(base: self)
        let requestString = "\(endPoint.method) \(endPoint.baseURL) \(endPoint.path)"
        
        return Self.moya.rx.request(endPoint)
            .filterSuccessfulStatusCodes()
    }
}


