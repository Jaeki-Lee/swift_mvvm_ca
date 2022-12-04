//
//  RequestLoggingPlugin.swift
//  Task
//
//  Created by trost.jk on 2022/09/16.
//

import Moya

//NetworkLoggerPlugin: Provider 이용해 네트워크를 호출 하는데, provider 를 생성할 때 plugin 을 넣어주면 willSend, didReceive 를 통해 log 를 확인 할 수 있다.
struct NetworkLoggerPlugin: PluginType {
    /// Called immediately before a request is sent over the network (or stubbed).
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            print("HTTP Request invalid request")
            return
        }
        
        //url 주소
        let url = httpRequest.description
        //request method
        let method = httpRequest.httpMethod ?? "unknown method"
        
        //target 사용하는 custom Target
        var httpLog = """
                    [HTTP Request]
                    URL: \(url)
                    TARGET: \(target)
                    METHOD: \(method)\n
                    """
        /// HTTP Request Header
        httpLog.append("HEADER: [\n")
        httpRequest.allHTTPHeaderFields?.forEach {
            httpLog.append("\t\($0): \($1)\n")
        }
        httpLog.append("]\n")
        
        /// HTTP Request Body
        if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            httpLog.append(contentsOf: "\n\(bodyString)\n")
        }
        httpLog.append("[HTTP Request End]")
        
        print(httpLog)
        
    }
    /// Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            onSuceed(response, target: target, isFromError: false)
        case let .failure(error):
            onFail(error, target: target)
        }
    }
    
    func onSuceed(_ response: Response, target: TargetType, isFromError: Bool) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        
        /// HTTP Response Summary
        var httpLog = """
                      [HTTP Response]
                      TARGET: \(target)
                      URL: \(url)
                      STATUS CODE: \(statusCode)\n
                      """
        /// HTTP Response Header
        httpLog.append("HEADER: [\n")
        response.response?.allHeaderFields.forEach{
            httpLog.append("\t\($0): \($1)\n")
        }
        httpLog.append("]\n")
        
        /// HTTP Response Data
        httpLog.append("RESPONSE DATA: \n")
        if let responseString = String(bytes: response.data, encoding: String.Encoding.utf8) {
            httpLog.append("\(responseString)\n")
        }
        httpLog.append("[HTTP Response End]")
        
        print(httpLog)
    }
    
    func onFail(_ error: MoyaError, target: TargetType) {
        if let response = error.response {
            onSuceed(response, target: target, isFromError: true)
            return
        }
        
        var httpLog = """
                      [HTTP Error]
                      TARGET: \(target)
                      ERRORCODE: \(error.errorCode)\n
                      """
        httpLog.append("MESSAGE: \(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
        httpLog.append("[HTTP Error End]")
        
        print(httpLog)
    }
    
    
}
