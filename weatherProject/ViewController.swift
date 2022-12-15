



import UIKit
import WeatherKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
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
    //테이블뷰
    @IBOutlet weak var weekWeatherTableView: UITableView!
    
    
    //    // 받아온 데이터를 저장할 프로퍼티
    //    var weather: Weather?
    //    var main: Main?
    //    var name: String?
    
    
    //서울의 좌표
    let seoul = CLLocation(latitude: 37.5666, longitude: 126.9784)
    //날씨 데이터 저장
    var weather: Weather?
    //10일간 최고 최저 온도
    var weekWeatherMaxTempArray: [String] = []
    var weekWeatherMinTempArray: [String] = []
    var weekWeatherSymbolArray: [String] = []
    
    
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
        //테이블뷰 델리케이트 설정
        weekWeatherTableView.delegate = self
        weekWeatherTableView.dataSource = self
        
        //위치 매니저 생성 및 설정
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //위치 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //위치 업데이트
        locationManager.startUpdatingLocation()
        
        let weatherService = WeatherService.shared
        
        DispatchQueue.main.async {
            Task {
                do {
                    self.weather = try await weatherService.weather(for: self.seoul)
                    self.setWeatherUI()
                    for j in 0...9 {
                        self.weekWeatherMaxTempArray.insert("\(Int(self.weather!.dailyForecast[j].highTemperature.value))º", at: j)
                        self.weekWeatherMinTempArray.insert("\(Int(self.weather!.dailyForecast[j].lowTemperature.value))º", at: j)
                        self.weekWeatherSymbolArray.insert(self.weather!.dailyForecast[j].symbolName, at: j)
                    }
                } catch {
                    print("error")
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // data fetch(데이터 요청)
        //        WeatherService().getWeather { result in
        //            switch result {
        //            case .success(let weatherResponse):
        //                DispatchQueue.main.async {
        //                    self.weather = weatherResponse.weather.first
        //                    self.main = weatherResponse.main
        //                    self.name = weatherResponse.name
        //                    self.setWeatherUI()
        //                }
        //            case .failure(_ ):
        //                print("error")
        //            }
        //        }
        
        
    }
    
    func setupUI() {
        //view들 모서리 커브
        firstview.layer.cornerRadius = 15
        LYtempView.layer.cornerRadius = 15
        calenderView.layer.cornerRadius = 15
        otherOptionView.layer.cornerRadius = 15
        weatherView.layer.cornerRadius = 15
        
        firstview.backgroundColor = UIColor(patternImage: UIImage(named: "earthBackGround")!)
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
        //        weatherTempLabel.text = "\(Int(main!.temp - 273.15))ºC"
        //        weatherMaxTempLabel.text = "최고:\(Int(main!.temp_max - 273.15))ºC"
        //        weatherMinTempLabel.text = "최저:\(Int(main!.temp_min - 273.15))ºC"
        //현재온도
        weatherTempLabel.text = "\(Int(weather!.currentWeather.temperature.value))º"
        //최고온도
        weatherMaxTempLabel.text = "최고:\(Int(weather!.dailyForecast[0].highTemperature.value))º"
        //최저온도
        weatherMinTempLabel.text = "최저:\(Int(weather!.dailyForecast[0].lowTemperature.value))º"
        //심볼네임
        weatherImage.image = UIImage(named: weather!.currentWeather.symbolName)
        print(weather!.currentWeather.symbolName)
    }
    
    //테이블뷰 셀의 숫자
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    //테이블뷰 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weekWeatherTableView.dequeueReusableCell(withIdentifier: "WeekWeatherTableViewCell", for: indexPath) as! WeekWeatherTableViewCell
        cell.selectionStyle = .none
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        var weekDayArray: [String] = ["오늘"]
        
        for i in 1...9 {
            weekDayArray.insert(formatter.string(from: Date(timeIntervalSinceNow: 86400 * Double(i))), at: i)
        }
        
        cell.weekDay.text = weekDayArray[indexPath.row]
        
        if self.weekWeatherMaxTempArray.count == 10, self.weekWeatherSymbolArray.count == 10 {
            cell.weekWeatherMaxTemp.text = self.weekWeatherMaxTempArray[indexPath.row]
            cell.weekWeatherMinTemp.text = self.weekWeatherMinTempArray[indexPath.row]
            cell.weekWeatherImage.image = UIImage(named: self.weekWeatherSymbolArray[indexPath.row])
        }
        
        return cell
    }
    
}

class WeekWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var weekWeatherMinTemp: UILabel!
    @IBOutlet weak var weekWeatherMaxTemp: UILabel!
    @IBOutlet weak var weekWeatherImage: UIImageView!
}


