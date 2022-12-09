



import UIKit
import WeatherKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // -MARK: iboutlet
    //첫번째 뷰
    @IBOutlet weak var firstview: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    //작년 날씨 뷰
    @IBOutlet weak var LYtempView: UIView!
    @IBOutlet weak var LYWeatherImage: UIImageView!
    @IBOutlet weak var LYWeatherLabel: UILabel!
    //캘린더 뷰
    @IBOutlet weak var calenderView: UIView!
    //기능 뷰
    @IBOutlet weak var otherOptionView: UIView!
    //현재 날씨 뷰
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherRegionLabel: UILabel!
    @IBOutlet weak var weatherTempLabel: UILabel!
    @IBOutlet weak var weatherDateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherMaxTempLabel: UILabel!
    @IBOutlet weak var weatherMinTempLabel: UILabel!
    //페이지컨트롤
    @IBOutlet weak var weatherPageControl: UIPageControl!
    
        // 받아온 데이터를 저장할 프로퍼티
        var weather: Weather?
        var main: Main?
        var name: String?
    
    
//    //날씨서비스 생성
//    let weatherService = WeatherService()
//    //위치매니저 생성
//    var locationManager: CLLocationManager!
//    //서울의 좌표
//    let seoul = CLLocation(latitude: 37.7749, longitude: 122.4194)
//    //    //날씨 데이터 저장
//    var weather: Weather?
//    var currentWeather: CurrentWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ui함수
        setupUI()
        setupWeatherUI()
        
        //view를 클릭 가능하도록 설정
        self.firstview.isUserInteractionEnabled = true
        self.calenderView.isUserInteractionEnabled = true
        self.weatherView.isUserInteractionEnabled = true
        //제쳐스 추가
        self.firstview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.firstViewTapped)))
        self.calenderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.calenderViewTapped)))
        self.weatherView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.weatherViewTapped)))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
                // data fetch(데이터 요청)
                WeatherService().getWeather { result in
                    switch result {
                    case .success(let weatherResponse):
                        DispatchQueue.main.async {
                            self.weather = weatherResponse.weather.first
                            self.main = weatherResponse.main
                            self.name = weatherResponse.name
                            self.setWeatherUI()
                        }
                    case .failure(_ ):
                        print("error")
                    }
                }
        
        
        
//        //위치 매니저 생성 및 설정
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        //위치 정확도
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        //위치 업데이트
//        locationManager.startUpdatingLocation()
//        //위도 경도 가져오기
//        let coor = locationManager.location!.coordinate
//        let currentLocation = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
//
//        getCurrentWeather(CLlocation: currentLocation) {
//            DispatchQueue.main.async {
//                self.setWeatherUI()
//            }
//        }
        
    }
//    //weatherkit으로 현재날씨 가져오기
//    func getCurrentWeather(CLlocation: CLLocation, completion: @escaping () -> Void){
//        Task {
//            do {
//                let result = try await weatherService.weather(for: CLlocation)
//                weather? = result
//            } catch {
//                print(error)
//            }
//        }
//        completion()
//    }
//
    func setupUI() {
        //view들 모서리 커브
        firstview.layer.cornerRadius = 15
        LYtempView.layer.cornerRadius = 15
        calenderView.layer.cornerRadius = 15
        otherOptionView.layer.cornerRadius = 15
        weatherView.layer.cornerRadius = 15
        
        //        firstview.backgroundColor = UIColor(patternImage: UIImage(named: "firstViewBack")!)
    }
    
    //오늘 날씨뷰 ui
    func setupWeatherUI() {
        //오늘 날짜 표시
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 d일 (E)"
        weatherDateLabel.text = formatter.string(from: Date())
        
        weatherRegionLabel.text = "서울"
    }
    
    //첫번째 뷰를 눌렀을 때
    @objc func firstViewTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showFirstView", sender: sender)
    }
    //캘린더뷰를 눌렀을 때
    @objc func calenderViewTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showCalenderView", sender: sender)
    }
    //현재 날씨 뷰를 눌렀을 때
    @objc func weatherViewTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showCurrentWeatherView", sender: sender)
    }
    
    //페이지컨트롤
    @IBAction func pageChanged(_ sender: UIPageControl) {
        
    }
    //현재 온도 세팅
    private func setWeatherUI() {
                weatherTempLabel.text = "\(Int(main!.temp - 273.15))ºC"
                weatherMaxTempLabel.text = "최고:\(Int(main!.temp_max - 273.15))ºC"
                weatherMinTempLabel.text = "최저:\(Int(main!.temp_min - 273.15))ºC"
//        weatherTempLabel.text = "\(weather?.currentWeather.temperature.value)"
    }
}
