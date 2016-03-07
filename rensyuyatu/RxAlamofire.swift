//
//  RxAlamofire.swift
//  rensyuyatu
//
//  Created by MaedaRyoto on 2016/03/08.
//  Copyright © 2016年 ika. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

extension Request {

    func rx_response(cancelOnDispose: Bool = false) -> Observable<NSData> {
        return Observable.create { observer -> Disposable in
            self.response { request, response, data, error in
                if let e = error as NSError? {
                    observer.onError(e)
                } else {
                    if let d = data {
                        if 200 ..< 300 ~= response?.statusCode ?? 0 {
                            observer.onNext(d)
                            observer.onCompleted()
                        } else {
                            observer.onError(
                                NSError(domain: "error: \(response?.statusCode ?? -1)",
                                code: -1,
                                userInfo: nil))
                        }
                    } else {
                        observer.onError(error ??
                            NSError(domain: "Empty data received", code: -1, userInfo: nil))
                    }
                }
            }
            return AnonymousDisposable {
                if cancelOnDispose {
                    self.cancel()
                }
            }
        }
    }

    func rx_responseString(encoding: NSStringEncoding? = nil,
                           cancelOnDispose: Bool = false) -> Observable<String> {
        return Observable.create { observer -> Disposable in
            self.responseString(encoding: encoding) { responseData in
                let result = responseData.result
                let response = responseData.response

                switch result {
                case .Success(let s):
                    if 200 ..< 300 ~= response?.statusCode ?? 0 {
                        observer.onNext(s)
                        observer.onCompleted()
                    } else {
                        observer.onError(NSError(domain: "error: \(response?.statusCode ?? -1)",
                            code: -1,
                            userInfo: nil))
                    }
                case .Failure(let e):
                    observer.onError(e)
                }
            }

            return AnonymousDisposable {
                if cancelOnDispose {
                    self.cancel()
                }
            }
        }
    }

    func rx_responseJSON(options: NSJSONReadingOptions = .AllowFragments,
                         cancelOnDispose: Bool = false) -> Observable<AnyObject> {

        return Observable.create { observer in
            self.responseJSON(options: options) { responseData in
                let result = responseData.result
                let response = responseData.response

                switch result {
                case .Success(let d):
                    if 200 ..< 300 ~= response?.statusCode ?? 0 {
                        observer.onNext(d)
                        observer.onCompleted()
                    } else {
                        observer.onError(NSError(domain: "error: \(response?.statusCode ?? -1)",
                            code: -1,
                            userInfo: nil))
                    }
                case .Failure(let e):
                    observer.onError(e)
                }
            }
            return AnonymousDisposable {
                if cancelOnDispose {
                    self.cancel()
                }
            }
        }
    }

    func rx_responsePropertyList(options: NSPropertyListReadOptions = NSPropertyListReadOptions(),
                                 cancelOnDispose: Bool = false) -> Observable<AnyObject> {

        return Observable.create { observer in
            self.responsePropertyList(options: options) { responseData in
                let result = responseData.result
                let response = responseData.response
                switch result {
                case .Success(let d):
                    if 200 ..< 300 ~= response?.statusCode ?? 0 {
                        observer.onNext(d)
                        observer.onCompleted()
                    } else {
                        observer.onError(NSError(domain: "error: \(response?.statusCode ?? -1)",
                            code: -1,
                            userInfo: nil))
                    }
                case .Failure(let e):
                    observer.onError(e)
                }
            }
            return AnonymousDisposable {
                if cancelOnDispose {
                    self.cancel()
                }
            }
        }
    }
}

// MARK: Request - Upload and download progress
extension Request {
    func rx_progress() -> Observable<(Int64, Int64, Int64)> {
        return Observable.create { observer in
            self.progress() { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                observer.onNext((bytesWritten, totalBytesWritten, totalBytesExpectedToWrite))
            }
            return AnonymousDisposable {
            }
        }
    }
}
