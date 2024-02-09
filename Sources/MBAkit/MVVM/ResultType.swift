//
//  ResultType.swift
//  MBArchitecture
//
//  Created by Moonbeom KWON on 2023/08/27.
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
