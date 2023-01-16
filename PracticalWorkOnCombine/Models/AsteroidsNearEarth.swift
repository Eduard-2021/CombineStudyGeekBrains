//
//  AsteroidsNearEarth.swift
//  PracticalWorkOnCombine
//
//  Created by Eduard on 13.02.2022.
//

import Foundation

struct AsteroidsNearEarth: Codable {
    var elementCount: Int
    var nearEarthObjects: NearEarthObjects
 
}

extension AsteroidsNearEarth {
    enum CodingKeys: String, CodingKey {
        case elementCount = "element_count"
        case nearEarthObjects = "near_earth_objects"
    }
}

struct NearEarthObjects: Codable {
    var rendezvousDate: [Asteroid]
}

extension NearEarthObjects {
    enum CodingKeys: String, CodingKey {
        case rendezvousDate = "2022-02-13"
    }
}


struct Asteroid: Codable {
    var id: String
    var name: String
    var estimatedDiameter: Diameter
    var isPotentiallyHazardousAsteroid: Bool
    var otherSpecifications: [OtherSpecifications]
    var isSentryObject: Bool
}


extension Asteroid {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case estimatedDiameter = "estimated_diameter"
        case isPotentiallyHazardousAsteroid = "is_potentially_hazardous_asteroid"
        case otherSpecifications = "close_approach_data"
        case isSentryObject = "is_sentry_object"
    }
}


struct Diameter: Codable {
    var meters: TwoValues
}

struct TwoValues: Codable {
    var estimatedDiameterMin: Double
    var estimatedDiameterMax: Double
}

extension TwoValues {
    enum CodingKeys: String, CodingKey {
        case estimatedDiameterMin = "estimated_diameter_min"
        case estimatedDiameterMax = "estimated_diameter_max"
    }
}


struct OtherSpecifications: Codable {
    var relativeVelocity: RelativeVelocity
    var missDistance: MissDistance
}

extension OtherSpecifications {
    enum CodingKeys: String, CodingKey {
        case relativeVelocity = "relative_velocity"
        case missDistance = "miss_distance"
    }
}

struct RelativeVelocity: Codable {
    var kilometersPerSecond: String
}

extension RelativeVelocity {
    enum CodingKeys: String, CodingKey {
        case kilometersPerSecond = "kilometers_per_second"
    }
}

struct MissDistance: Codable {
    var kilometers: String
}
