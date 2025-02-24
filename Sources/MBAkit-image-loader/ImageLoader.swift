//
//  ImageLoader.swift
//  FunctionalDataManager
//
//  Created by Moonbeom KWON on 2/6/24.
//

import Foundation
import ResultExtensions

public class ImageLoader {
    struct ImageData: Codable {
        let data: Data
        let url: String
    }
    
    static func loadImage(with imageURL: URL) async -> Result<ImageData, Error> {
        return await DataManager.default.loadObject(object: .cache, forKey: imageURL.absoluteString)
            .decode(decoder: ImageData.self)
            .asyncFlatMapError({ _ in await ImageLoader.loadImageData(from: imageURL) })
            .map { imageData in
                Task {
                    await DataManager.default.saveObject(object: .cache(data: imageData.data),
                                                         forKey: imageURL.absoluteString)
                }
                return imageData
            }
    }
}

extension ImageLoader {
    private static func loadImageData(from imageURL: URL) async -> Result<ImageData, Error> {
        do {
            let (data, response) = try await URLSession.shared.data(from: imageURL)
            let urlKey = response.url?.absoluteString ?? imageURL.absoluteString
            return .success(ImageData(data: data, url: urlKey))
            
        } catch let error {
            return .failure(error)
        }
    }
}
