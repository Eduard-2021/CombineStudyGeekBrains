//
//  APIClient.swift
//  PracticalWorkOnCombine
//
//  Created by Eduard on 13.02.2022.
//

import UIKit
import Combine

struct APIClient {
    enum Method: String {
        case feed = "https://api.nasa.gov/neo/rest/v1/feed?start_date=2022-02-13&end_date=2022-02-13&api_key=DEMO_KEY"
        case APOD = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
        
        var url: URL {
              switch self {
              case .feed:
                  return URL(string: self.rawValue)!
              case .APOD:
                  return URL(string: self.rawValue)!
            }
        }
    }
    
    private let decoder = JSONDecoder()
    private let queue = DispatchQueue(label: "APIClient", qos: .default, attributes: .concurrent)

    func feed() -> AnyPublisher<AsteroidsNearEarth, Error> {
         return URLSession.shared
             .dataTaskPublisher(for: Method.feed.url)
             .receive(on: queue)
             .map(\.data)
             .decode(type: AsteroidsNearEarth.self, decoder: decoder)
             .mapError({ error -> Error in
                 switch error {
                 case is URLError:
                   return Error.unreachableAddress(url: Method.feed.url)
                 default:
                   return Error.invalidResponse }
             })
             .eraseToAnyPublisher()
     }
    
    
    func apod() -> AnyPublisher<APOD, Error> {
         return URLSession.shared
             .dataTaskPublisher(for: Method.APOD.url)
             .receive(on: queue)
             .map(\.data)
             .decode(type: APOD.self, decoder: decoder)
             .mapError({ error -> Error in
                 switch error {
                 case is URLError:
                   return Error.unreachableAddress(url: Method.APOD.url)
                 default:
                   return Error.invalidResponse }
             })
             .eraseToAnyPublisher()
     }
    
    
    enum Error: LocalizedError {
            
         case unreachableAddress(url: URL)
         case invalidResponse
            
         var errorDescription: String? {
             switch self {
             case .unreachableAddress(let url): return "\(url.absoluteString) is unreachable"
             case .invalidResponse: return "Response with mistake"
             }
         }
    }
}

