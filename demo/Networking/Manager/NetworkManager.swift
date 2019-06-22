//
//  NetworkManager.swift
//  demo
//
//  Created by Chun yu Tung on 2019/5/16.
//  Copyright © 2019 Chun yu Tung. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
    case success
    case parameterError = "Client provided incorrect parameters for the request."
    case tooOftenError = "Request limit. Please Wait for 2 minutes."
    case notFoundError = "Resource was not found."
    case amountError = "Request was throttled, because amount of requests was above the threshold defined for the used API token."
    case UnknownError = "Unknown error happened when handling the request."
    case ServiceError = "Service is temprorarily unavailable because of maintenance."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    
}

enum Result<String> {
    case success
    case failure(String)
}

struct NetworkManager {
    static let environment: NetworkEnvironment = .demo
    private let router = Router<CocApi>()

    func getPlayerData(tag: String, completion: @escaping (_ data: Data?, _ error : String?) -> () ) {
        router.request(.player(tag: tag)) { (data, response, error) in
            if error != nil {
                completion(nil,"Please check your network connection.")
            }
            if let response = response as? HTTPURLResponse {
                print("statusCode:\(response.statusCode)")
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    if let responseData = data {
                        completion(responseData, nil)
                    } else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
        
    }
    
    func getImageDataFromUrl(urlStr: String, completion: @escaping (_ data: Data?, _ error : String? ) -> () ) {
        let session = URLSession(configuration: .default)
        guard let imageUrl = URL(string: urlStr) else {
            completion(nil,"Please check the URL.")
            return
        }
        let task = session.dataTask(with: imageUrl) { (data, response, error) in
            if error != nil {
                completion(nil,"Please check your network connection.")
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil,"response error.")
                return
            }
            completion(data,nil)
        }
        task.resume()
    }

    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 400: return .failure(NetworkResponse.parameterError.rawValue)
        case 403: return .failure(NetworkResponse.tooOftenError.rawValue)
        case 404: return .failure(NetworkResponse.notFoundError.rawValue)
        case 429: return .failure(NetworkResponse.amountError.rawValue)
        case 500: return .failure(NetworkResponse.UnknownError.rawValue)
        case 503: return .failure(NetworkResponse.ServiceError.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

