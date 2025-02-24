//
//  ResponseType.swift
//  FunctionalURLSession
//
//  Created by Moonbeom KWON on 2/7/25.
//

import Foundation

public enum ErrorType: Error {
    case invalidURL
    case badResponse
    case invalidFormat
    case invalidJSON
    case parsingError
    case invalidLocation
    case noFilePath
    case fileNotFound
}

public enum ResponseType {
    case rawData(data: Data)
    case jsonArray(array: [Any])
    case jsonDic(dic: [String: Any])
}

public extension Result where Success == ResponseType {
    func decode<T: Decodable>(decoder: T.Type) -> Result<T, Error> {
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


