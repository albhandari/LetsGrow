//
//  MockNetworkingManagerImpl.swift
//  LetsGrow
//
//  Created by Alex Bhandari on 1/6/24.
//

import Foundation

class MockNetworkingManagerImpl: NetworkingManager{
    
    func fetchData(source: URL) async throws -> Data {
        let fetchedJson = """
         {
             "status": "ok",
             "totalResults": 595,
             "articles": [
                 {
                     "source": {
                         "id": null,
                         "name": "Boing Boing"
                     },
                     "author": "David Pescovitz",
                     "title": "Grow freaky fruit in the shape of people's faces",
                     "description": "Weird Universe introduces us to gardening enthusiast and toy designer Richard Tweddell III of Cincinnati, Ohio who, in 1987, patented a method to grow squask, cucumbers, and other fruit in the shape of faces and other objects. \n\n\n\n\"A clear two-piece plastic m…",
                     "url": "https://boingboing.net/2023/12/13/grow-fruit-in-the-shape-of-peoples-faces.html",
                     "urlToImage": "https://i0.wp.com/boingboing.net/wp-content/uploads/2023/12/vegiforms02.jpg?fit=1200%2C936&ssl=1",
                     "publishedAt": "2023-12-13T22:16:05Z",
                     "content": "Weird Universe introduces us to gardening enthusiast and toy designer Richard Tweddell III of Cincinnati, Ohio who, in 1987, patented a method to grow squask, cucumbers, and other fruit in the shape … [+731 chars]"
                 },
                 {
                     "source": {
                         "id": null,
                         "name": "Boing Boing"
                     },
                     "author": "David Pescovitz",
                     "title": "A boring looking lawn ornament's explosive secret",
                     "description": "In Sian and Jeffrey Edwards's Pembrokeshire, England back yard, a lawn ornament held an explosive secret. They knew that the phallic object was an old naval shell that a prior owner had spotted on the beach as a youngster more than a century ago. — Read the r…",
                     "url": "https://boingboing.net/2023/12/04/a-boring-looking-lawn-ornaments-explosive-secret.html",
                     "urlToImage": "https://i0.wp.com/boingboing.net/wp-content/uploads/2023/12/ghardennnbombeeee.jpg?fit=1200%2C675&ssl=1",
                     "publishedAt": "2023-12-04T17:46:17Z",
                     "content": "In Sian and Jeffrey Edwards's Pembrokeshire, England back yard, a lawn ornament held an explosive secret. They knew that the phallic object was an old naval shell that a prior owner had spotted on th… [+1193 chars]"
                 }
             ]
         }
        """
        let data = fetchedJson.data(using: .utf8)!
        print(data.description)
        return data
    }
    
    
}
