//
//  ResultExtension.swift
//  MBArchitecture
//
//  Created by Moonbeom KWON on 2023/08/25.
//

import Foundation

extension Result where Success == ResponseType, Failure == Error {
    
    public func decode<T: Decodable>(decoder: T.Type) -> Result<T, Error> {
        switch self {
        case .success(let responseData):
            switch responseData {
            case .rawData(let data):
                do {
                    let dataModel = try JSONDecoder().decode(decoder, from: data)
                    return .success(dataModel)
                } catch let error {
                    return .failure(error)
                }
            case .jsonDic(let jsonDic):
                do {
                    let data = try JSONSerialization.data(withJSONObject: jsonDic,
                                                          options: [.fragmentsAllowed])
                    let dataModel = try JSONDecoder().decode(T.self, from: data)
                    return .success(dataModel)
                } catch {
                    return .failure(ErrorType.parsingError)
                }
            case .jsonArray(let jsonDicArray):
                do {
                    let data = try JSONSerialization.data(withJSONObject: jsonDicArray,
                                                          options: [.fragmentsAllowed])
                    let dataModel = try JSONDecoder().decode(T.self, from: data)
                    return .success(dataModel)
                } catch {
                    return .failure(ErrorType.parsingError)
                }
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
