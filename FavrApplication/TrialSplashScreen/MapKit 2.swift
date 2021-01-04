//
//  MapKit.swift
//  Favr
//
//  Created by Aniket Gupta on 25/07/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
  var coordinate: CLLocationCoordinate2D
  
  func makeUIView(context: Context) -> MKMapView {
    MKMapView(frame: .zero)
  }
  
  func updateUIView(_ view: MKMapView, context: Context) {
    let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    view.setRegion(region, animated: true)
  }
}

#if DEBUG
struct MapView_Previews : PreviewProvider {
  static var previews: some View {
    MapView(coordinate: CLLocationCoordinate2DMake(0,0))
  }
}
#endif
