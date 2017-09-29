//
//  Events.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/09/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

protocol Event {}

struct NoJwtTokenFoundEvent: Event {}
struct GetJwtTokenEvent: Event {}
struct JwtTokenFoundEvent: Event {
    var jwtToken: String
}
struct ErrorTryingGetJwtTokenEvent: Event {
    var error: AAError?
}
