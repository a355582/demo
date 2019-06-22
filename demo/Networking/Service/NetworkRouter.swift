//
//  NetworkRouter.swift
//  demo
//
//  Created by Chun yu Tung on 2019/5/15.
//  Copyright © 2019 Chun yu Tung. All rights reserved.
//

import Foundation
public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
