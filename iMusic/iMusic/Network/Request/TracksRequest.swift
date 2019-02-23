//
//  TracksRequest.swift
//  iMusic
//
//  Created by Ricardo Casanova on 23/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import Foundation

struct TracksRequest: RequestProtocol {
    
    typealias ResponseType = TracksResponse
    var completion: ((Result<TracksResponse?>) -> Void)?
    var method: HTTPMethod = .get
    var url: URL?
    var encodableBody: Encodable?
    var simulatedResponseJSONFile: String?
    var verbose: Bool?
    var contentType: ContentType = .json
    var processHeader: Bool?
    var shouldRetry: Bool = true
    
    init(search: String?) {
        url = Endpoint.getArtistWith(search: search).url
    }
    
}
