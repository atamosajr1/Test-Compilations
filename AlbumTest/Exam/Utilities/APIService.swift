//
//  APIService.swift
//  Exam
//
//  Created by JayR- Mac-mini on 10/22/21.
//

import UIKit

class APIService: NSObject {
    static let shared = APIService()
        
    var baseURL: NSURL?
    
    //Initializer
    private override init(){
    }
        
    func getAlbumsList(offset: Int, count: Int, completion: @escaping (_ result :  Result?,_ error : Error?) -> Void) {
        let requestURL = URL(string: "https://api-metadata-connect.tunedglobal.com/api/v2.1/albums/trending?offset=\(offset)&count=\(count)")
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue("luJdnSN3muj1Wf1Q", forHTTPHeaderField:"StoreId")
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(Result.self, from: data)
                completion(result, error)
            } catch {
                print("Error : \(error)")
            }
        }

        task.resume()
    }
}


