//
//  MovieRepository.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 4/22/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

/**
 
Remote repository abstact class for network based repositories
 
*/

class RemoteRepository: RepositoryProtocol {
    
    /**
    Responsible for network calls use **Alamofire** under the hood,

    - Parameter requestConverter: Accepts Alamofire 'RequestConverter' as network request

    - Parameter completion: Completion block
    
    - Parameter response: Generic param confirms to **Mappable** as success response mapped automatically to class
     
    - Parameter error: Error on API failure

    - Returns: New network request refrence.
    */
    
    func request<T: Mappable>(requestConverter: RequestConverter, completion:@escaping (_ response: T?, _ error: Error?) -> Void) -> Void {
        Alamofire.request(requestConverter).validate().responseObject { (response:DataResponse<T>) in
            switch response.result {
            case .success(let value):
                completion(value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
}
