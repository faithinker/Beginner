
import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import MapKit

class DelegateProxyViewController: UIViewController {
   
   let bag = DisposeBag()
   
   @IBOutlet weak var mapView: MKMapView!
   
   let locationManager = CLLocationManager()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      
   }
}


extension Reactive where Base: MKMapView {
   public var center: Binder<CLLocation> {
      return Binder(self.base) { mapView, location in
         let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
         self.base.setRegion(region, animated: true)
      }
   }
}


