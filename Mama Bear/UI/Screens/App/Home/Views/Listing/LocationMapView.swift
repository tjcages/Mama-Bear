//
//  LocationMapView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/21/20.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    @ObservedObject var listingCellVM: ListingCellViewModel
    
    @State var region = MKCoordinateRegion(center: .init(latitude: 39.541000, longitude: -104.988140), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom, spacing: Sizes.xSmall) {
                Text("Location")
                    .customFont(.medium, category: .large)
                    .foregroundColor(Colors.headline)
                    .padding(.top, Sizes.Default)
                    .padding(.leading, Sizes.Default)

                Text(listingCellVM.listing.distanceText)
                    .customFont(.medium, category: .small)
                    .foregroundColor(Colors.headline)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(
                        Colors.backgroundInvert
                            .opacity(0.1)
                            .cornerRadius(Sizes.Spacer)
                    )
            }

            Map(coordinateRegion: .constant(region), annotationItems: getRegion(lat: listingCellVM.listing.addressLat, long: listingCellVM.listing.addressLong)) { location in
                MapAnnotation(coordinate: location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                    Circle()
                        .stroke(Colors.blue)
                        .frame(width: Sizes.Big * 2, height: Sizes.Big * 2)
                        .background(
                            Colors.blue
                                .opacity(0.3)
                                .cornerRadius(Sizes.Big)
                        )
                }
            }
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.width * 2 / 3)
                .disabled(true)
                .frame(maxWidth: .infinity)
                .background(Colors.cellBackground)
                .cornerRadius(Sizes.xSmall)
                .padding(.horizontal, Sizes.Default)
        }
    }
    
    private func getRegion(lat: Double, long: Double) -> [ListingLocation] {
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06))
        }
        return [ListingLocation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))]
    }
}
