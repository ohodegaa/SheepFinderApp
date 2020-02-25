//
//  utils.swift
//  SheepFinder
//
//  Created by Ole Håkon Ødegaard on 13/02/2020.
//  Copyright © 2020 Ole Håkon Ødegaard. All rights reserved.
//

import MapKit

func sortConvex(input: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {

	// X = longitude
	// Y = latitude

	// 2D cross product of OA and OB vectors, i.e. z-component of their 3D cross product.
	// Returns a positive value, if OAB makes a counter-clockwise turn,
	// negative for clockwise turn, and zero if the points are collinear.
	func cross(P: CLLocationCoordinate2D, _ A: CLLocationCoordinate2D, _ B: CLLocationCoordinate2D) -> Double {
		let part1 = (A.longitude - P.longitude) * (B.latitude - P.latitude)
		let part2 = (A.latitude - P.latitude) * (B.longitude - P.longitude)
		return part1 - part2;
	}

	// Sort points lexicographically
	let points = input.sorted(by: { $0.longitude == $1.longitude ? $0.latitude < $1.latitude: $0.longitude < $1.longitude })

	// Build the lower hull
	var lower: [CLLocationCoordinate2D] = []
	for p in points {
		while lower.count >= 2 && cross(P: lower[lower.count - 2], lower[lower.count - 1], p) <= 0 {
			lower.removeLast()
		}
		lower.append(p)
	}

	// Build upper hull
	var upper: [CLLocationCoordinate2D] = []
	for p in points.reversed() {
		while upper.count >= 2 && cross(P: upper[upper.count - 2], upper[upper.count - 1], p) <= 0 {
			upper.removeLast()
		}
		upper.append(p)
	}

	// Last point of upper list is omitted because it is repeated at the
	// beginning of the lower list.
	upper.removeLast()

	// Concatenation of the lower and upper hulls gives the convex hull.
	return (upper + lower)
}
