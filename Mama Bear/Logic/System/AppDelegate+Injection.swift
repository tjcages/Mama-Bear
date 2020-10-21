//
//  AppDelegate+Injection.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { FirestoreListingRepository() as ListingRepository }.scope(application)
        register { FirestoreFAQRepository() as BaseFAQRepository }.scope(application)
        register { AuthenticationService() }.scope(application)
    }
}
