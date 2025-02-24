//
//  DataManager.swift
//  FunctionalDataManager
//
//  Created by Moonbeom KWON on 2/6/25.
//

import Foundation

public actor DataManager {
    static let `default` = DataManager()
    private init() { }
    
    private lazy var memCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = 100_000_000
        return cache
    }()
}

// MARK: - define errors
public extension DataManager {
    enum ErrorType: Error {
        case noData
        case noFilePath
        case fileNotFound
    }
}

// MARK: - define types
public extension DataManager {
    
    enum DataLocationType {
        case cache
        case document
        
        var directoryPath: String? {
            switch self {
            case .cache:
                return NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                           .allDomainsMask, true).first
            case .document:
                return NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .allDomainsMask, true).first
            }
        }
    }
    
    enum DataStorageType {
        case cache(data: Data)
        case document(data: Data)
        
        var directoryPath: String? {
            self.locationType.directoryPath
        }
        
        var data: Data {
            switch self {
            case .cache(let data), .document(let data):
                return data
            }
        }
        
        private var locationType: DataLocationType {
            switch self {
            case .cache:
                return .cache
            case .document:
                return .document
            }
        }
    }
}

// MARK: - accessing cache
public extension DataManager {
    func loadObject(object: DataLocationType, forKey key: String) -> Result<Data, Error> {
        let cacheKey = NSString(string: key)
        if let cachedData = self.memCache.object(forKey: cacheKey) as? Data {
            return .success(cachedData)
        }
        
        guard let directoryPath = object.directoryPath else {
            return .failure(ErrorType.noFilePath)
        }
        
        return self.loadFile(from: directoryPath, forKey: key)
    }
    
    
    func saveObject(object: DataStorageType, forKey key: String) {
        let cacheKey = NSString(string: key)
        let cacheData = NSData(data: object.data)
        self.memCache.setObject(cacheData, forKey: cacheKey)
        
        guard let directoryPath = object.directoryPath else { return }
        
        Task {
            await self.saveFile(data: object.data, to: directoryPath, forKey: key)
        }
    }
}

// MARK: - file I/O
extension DataManager {
    private func loadFile(from directoryPath: String, forKey fileName: String) -> Result<Data, Error> {
        var data: Data?
        if #available(iOS 16.0, *) {
            let directoryURL = URL(filePath: directoryPath)
            let fileURL = directoryURL.appendingPathComponent(fileName)
            data = try? Data(contentsOf: fileURL)
            
        } else {
            // Fallback on earlier versions
            let directoryURL = URL(fileURLWithPath: directoryPath)
            let fileURL = directoryURL.appendingPathComponent(fileName)
            data = try? Data(contentsOf: fileURL)
        }
        
        if let data = data {
            return .success(data)
        } else {
            return .failure(ErrorType.fileNotFound)
        }
    }
    
    private func saveFile(data: Data, to directoryPath: String, forKey fileName: String) async {
        if #available(iOS 16.0, *) {
            let directoryURL = URL(filePath: directoryPath)
            let fileURL = directoryURL.appendingPathComponent(fileName)
            
            do {
                if !self.checkDirectory(directoryPath: directoryURL.absoluteString) {
                    try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
                }
                try data.write(to: fileURL)
            } catch let error {
                print(error.localizedDescription)
            }
            
        } else {
            // Fallback on earlier versions
            let directoryURL = URL(fileURLWithPath: directoryPath)
            let fileURL = directoryURL.appendingPathComponent(fileName)
            
            do {
                if !self.checkDirectory(directoryPath: directoryURL.absoluteString) {
                    try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
                }
                try data.write(to: fileURL)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - utility
extension DataManager {
    private func checkDirectory(directoryPath: String) -> Bool {
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: directoryPath, isDirectory: &isDirectory)
            || isDirectory.boolValue == false {
            return false
        }
        
        return true
    }
}
