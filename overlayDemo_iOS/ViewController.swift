//
//  ViewController.swift
//  overlayDemo_iOS
//
//  Created by Ankita Jain on 2020-01-10.
//  Copyright © 2020 Ankita Jain. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    
    let places=Place.getPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        addAnnotation()
        //addPolyLine()
        addPolygons()
    }
    
    func addAnnotation()  {
        mapView.delegate=self
        mapView.addAnnotations(places)
        
        let overlays=places.map { (MKCircle(center: $0.coordinate, radius: 100000))
        }

        mapView.addOverlays(overlays)
    }
    
    func addPolyLine()
    {
        let locations=places.map{$0.coordinate}
        let polyLine=MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(polyLine)
    }
    
    func addPolygons()
    {
        let locations=places.map{$0.coordinate}
               let polygon=MKPolygon(coordinates: locations, count: locations.count)
               mapView.addOverlay(polygon)
    }


}

extension ViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        else
        {
            let annotationView=mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image=UIImage(named: "ic_place")
            annotationView.canShowCallout=true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
    }
    
    //this function is need to add the overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle
        {
        let rendrer=MKCircleRenderer(overlay: overlay)
        rendrer.fillColor=UIColor.black.withAlphaComponent(0.5)
        rendrer.strokeColor=UIColor.green
        rendrer.lineWidth=2
        return rendrer
        }
        else if overlay is MKPolyline
        {
            let rendrer=MKPolylineRenderer(overlay: overlay)
            rendrer.strokeColor=UIColor.red
            rendrer.lineWidth=3
            return rendrer

        }
        
        else if overlay is MKPolygon
        {
            let rendrer=MKPolygonRenderer(overlay: overlay)
            rendrer.strokeColor=UIColor.blue
            rendrer.fillColor=UIColor.orange.withAlphaComponent(0.5)
            rendrer.lineWidth=3
            return rendrer
        }
        return MKOverlayRenderer()
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation=view.annotation as? Place, let title=annotation.title else{
            return
        }
        let alertController=UIAlertController(title: "Welcome to\(title)", message: "Have a good time in \(title)", preferredStyle: .alert)
        let cancelAction=UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController,animated: true,completion: nil)
    }
    

}
