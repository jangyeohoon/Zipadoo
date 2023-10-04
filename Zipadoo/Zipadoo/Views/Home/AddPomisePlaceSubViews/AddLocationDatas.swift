//
//  LocationDatas.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/25.
//

import SwiftUI
import CoreLocation

// MARK: - 사용 안함
/// 사용 안함
//struct AddLocation: Identifiable {
//    let id = UUID()
//    let coordinate: CLLocationCoordinate2D
//}

// MARK: - 직접 등록 맵뷰에 필요한 LocationManager 클래스
/// 직접 등록 맵뷰에 필요한 LocationManager 클래스
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
}
// MARK: - 장소 등록에 필요한 구조체 데이터
/// 장소 등록에 필요한 구조체 데이터
struct PromiseLocation: Identifiable, Codable {
    var id: UUID = UUID()
    var latitude: Double // 위도
    var longitude: Double // 경도
    var address: String // 주소
}

// MARK: - 직접 등록 맵뷰에 필요한 클래스 데이터
/// 직접 등록 맵뷰에 필요한 클래스 데이터
class AddLocationStore {
    func setLocation(latitude: Double, longitude: Double, address: String) -> PromiseLocation {
        let location = PromiseLocation(latitude: latitude, longitude: longitude, address: address)
        return location
    }
}