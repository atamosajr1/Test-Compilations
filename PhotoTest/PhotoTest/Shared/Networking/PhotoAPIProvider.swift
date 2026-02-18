//
//  PhotoAPIProvider.swift
//  PhotoTest
//
//  Created by JayR Atamosa on 3/9/23.
//

import Foundation
import Combine

protocol PhotoAPIProvider {
    func getPhotos() -> AnyPublisher<CuratedPhoto, Error>
}

class PhotoAPIClient: PhotoAPIProvider {
    var apiClient: APIProvider = APIClient.instance
    
    func getPhotos() -> AnyPublisher<CuratedPhoto, Error> {
        apiClient.request(PhotoAPIRouter.photos).decode()
    }
}

enum PhotoAPIRouter: RequestInfoConvertible {
    case photos
    
    var endpoint: String {
        "https://api.pexels.com/v1"
    }
    
    var urlString: String {
        "\(endpoint)/\(path)"
    }
    
    var path: String {
        switch self {
        case .photos:
            return "curated"
        }
    }
    
    func asRequestInfo() -> RequestInfo {
        let requestInfo: RequestInfo = RequestInfo(url: urlString, headers: ["Authorization": "ZHhzFzs6fqaNfv5tga0ZlykLJloX1PLHcM4iS9IMOLx95pfZuIpgnEoF"])
        return requestInfo
    }
}
