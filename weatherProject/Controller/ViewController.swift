



import UIKit
import WeatherKit
import CoreLocation
//hi
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
    //날씨 컨디션 저장
    var currentWeatherCondition = ""
    //시간당 온도
    var hourWeatherTempArray: [String] = []
    var hourWeatherSymbol: [String] = []
    //10일간 최고 최저 온도
    var weekWeatherMaxTempArray: [Int] = []
    var weekWeatherMinTempArray: [Int] = []
    var weekWeatherSymbolArray: [String] = []
    //오늘 온도, 최고 최저 온도, 심볼네임
    var currentWeatherTemp: Int = 0
    var currentWeatherSymbol = ""
    var dailyWeatherMaxTemp: Int = 0
    var dailyWeatherMinTemp: Int = 0
    //가시거리
    var currentWeatherVisibility: Int = 0
    //자외선 지수
    var currentWeatherUvIndex: Int = 0
    //풍속, 풍향
    var currentWeatherWindSpeed: Int = 0
    var currentWeatherWinddirection = ""
    //체감온도
    var currentWeatherApparentTemperature: Int = 0
    //습도
    var currentWeatherHumidity: Int = 0
    //이슬점
    var currentWeatherDewPoint: Int = 0
    //강수량
    var precipitation: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ui함수
        setupUI()
        
        //view를 클릭 가능하도록 설정
        self.firstview.isUserInteractionEnabled = true
        self.calenderView.isUserInteractionEnabled = true
        self.weatherView.isUserInteractionEnabled = true
        self.otherOptionView.isUserInteractionEnabled = true
        //제쳐스 추가
        self.firstview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.firstViewTapped)))
        self.calenderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.calenderViewTapped)))
        self.weatherView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.weatherViewTapped)))
        self.otherOptionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.otherOptionViewTapped)))
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
                    //10일간 날씨 받아오기
                    for i in 0...9 {
                        self.weekWeatherMaxTempArray.append(Int(round(self.weather!.dailyForecast[i].highTemperature.value)))
                        self.weekWeatherMinTempArray.append(Int(round(self.weather!.dailyForecast[i].lowTemperature.value)))
                        self.weekWeatherSymbolArray.append(self.weather!.dailyForecast[i].symbolName)
                    }
                    print(self.weekWeatherSymbolArray)
                    print(self.weather!.currentWeather.condition)
                    print(self.weather!.currentWeather.symbolName)
                    print(self.weather!.currentWeather.condition)
                    //현재시간 불러오기
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "ko")
                    formatter.dateFormat = "HH"
                    let currentHour = Int(formatter.string(from: Date()))!
                    //시간당 날씨 받아오기
                    for j in (currentHour + 2)...(currentHour + 25) {
                        self.hourWeatherTempArray.append("\(Int(round(self.weather!.hourlyForecast[j].temperature.value)))º")
                        self.hourWeatherSymbol.append(self.weather!.hourlyForecast[j].symbolName)
                    }

                    //현재 날씨 받아오기
                    self.currentWeatherCondition = self.weather!.currentWeather.condition.rawValue
                    self.dailyWeatherMaxTemp = Int(round(self.weather!.dailyForecast[0].highTemperature.value))
                    self.dailyWeatherMinTemp = Int(round(self.weather!.dailyForecast[0].lowTemperature.value))
                    self.currentWeatherSymbol = self.weather!.currentWeather.symbolName
                    self.currentWeatherTemp = Int(round(self.weather!.currentWeather.temperature.value))
                    self.currentWeatherVisibility = Int(round(self.weather!.currentWeather.visibility.value / 1000))
                    self.currentWeatherUvIndex = self.weather!.currentWeather.uvIndex.value
                    self.currentWeatherWindSpeed = Int(round(self.weather!.currentWeather.wind.speed.value / 3.6))
                    self.currentWeatherWinddirection = "\(self.weather!.currentWeather.wind.compassDirection.rawValue)"
                    print(self.currentWeatherWinddirection)
                    self.currentWeatherApparentTemperature = Int(round(self.weather!.currentWeather.apparentTemperature.value))
                    self.currentWeatherHumidity = Int(round(self.weather!.currentWeather.humidity * 100))
                    self.precipitation = Int(round(self.weather!.dailyForecast[0].precipitationChance * 100))
                    self.currentWeatherDewPoint = Int(round(self.weather!.currentWeather.dewPoint.value))
                    
                    //ui세팅
                    self.currentWeatherConditionKO()
                    self.setWeatherUI()
                    self.weekWeatherTableView.reloadData()
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
    
    //첫번째 뷰를 눌렀을 때
    @objc func firstViewTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showFirstView", sender: sender)
    }
    //캘린더뷰를 눌렀을 때
    @objc func calenderViewTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showCalenderView", sender: sender)
    }
    //검색뷰를 눌렀을 때
    @objc func otherOptionViewTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showSearchView", sender: sender)
    }
    //현재 날씨 뷰를 눌렀을 때
    @objc func weatherViewTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showCurrentWeatherView", sender: sender)
    }
    //currnetViewController로 데이터 전송
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCurrentWeatherView" {
            guard let vc = segue.destination as? CurrentWeatherViewController else { return }
            vc.currentWeatherCondition = self.currentWeatherCondition
            vc.hourWeatherTempArray = self.hourWeatherTempArray
            vc.weekWeatherSymbolArray = self.weekWeatherSymbolArray
            vc.weekWeatherMaxTempArray = self.weekWeatherMaxTempArray
            vc.weekWeatherMinTempArray = self.weekWeatherMinTempArray
            vc.currentWeatherTemp = self.currentWeatherTemp
            vc.currentWeatherSymbol = self.currentWeatherSymbol
            vc.dailyWeatherMaxTemp = self.dailyWeatherMaxTemp
            vc.dailyWeatherMinTemp = self.dailyWeatherMinTemp
            vc.hourWeatherSymbol = self.hourWeatherSymbol
            vc.currentWeatherVisibility = self.currentWeatherVisibility
            vc.currentWeatherUvIndex = self.currentWeatherUvIndex
            vc.currentWeatherWindSpeed = self.currentWeatherWindSpeed
            vc.currentWeatherWinddirection = self.currentWeatherWinddirection
            vc.currentWeatherApparentTemperature = self.currentWeatherApparentTemperature
            vc.currentWeatherHumidity = self.currentWeatherHumidity
            vc.currentWeatherDewPoint = self.currentWeatherDewPoint
            vc.precipitation = self.precipitation
        }
    }
    
    //페이지컨트롤
    @IBAction func pageChanged(_ sender: UIPageControl) {
        
    }
    
    //현재 온도 세팅
    private func setWeatherUI() {
        //오늘 날짜 표시
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 d일 (E)"
        weatherDateLabel.text = formatter.string(from: Date())
        weatherRegionLabel.text = "서울"
        
        weatherLabel.text = self.currentWeatherCondition
        //현재온도
        weatherTempLabel.text = "\(self.currentWeatherTemp)º"
        //최고온도
        weatherMaxTempLabel.text = "최고:\(self.dailyWeatherMaxTemp)º"
        //최저온도
        weatherMinTempLabel.text = "최저:\(self.dailyWeatherMinTemp)º"
        //심볼네임
        weatherImage.image = UIImage(named: self.currentWeatherSymbol)
    }
    
    //날씨 컨디션 케이스별 번역
    func currentWeatherConditionKO() {
        switch currentWeatherCondition {
        case "blowingDust":
            currentWeatherCondition = "먼지"
        case "clear":
            currentWeatherCondition = "맑음"
        case "cloudy":
            currentWeatherCondition = "흐림"
        case "foggy":
            currentWeatherCondition = "안개"
        case "haze":
            currentWeatherCondition = "연무"
        case "mostlyClear":
            currentWeatherCondition = "대체로 맑음"
        case "mostlyCloudy":
            currentWeatherCondition = "대체로 흐림"
        case "partlyCloudy":
            currentWeatherCondition = "한때 흐림"
        case "smoky":
            currentWeatherCondition = "연기"
        case "breezy":
            currentWeatherCondition = "미풍"
        case "windy":
            currentWeatherCondition = "바람"
        case "drizzle":
            currentWeatherCondition = "이슬비"
        case "heavyRain":
            currentWeatherCondition = "폭우"
        case "isolatedThunderstorms":
            currentWeatherCondition = "외딴뇌우"
        case "rain":
            currentWeatherCondition = "비"
        case "sunShowers":
            currentWeatherCondition = "소나기"
        case "scatteredThunderstorms":
            currentWeatherCondition = "흩어진뇌우"
        case "strongStorms":
            currentWeatherCondition = "폭풍"
        case "thunderstorms":
            currentWeatherCondition = "뇌우"
        case "frigid":
            currentWeatherCondition = "몹시 추움"
        case "hail":
            currentWeatherCondition = "우박"
        case "hot":
            currentWeatherCondition = "더움"
        case "flurries":
            currentWeatherCondition = "돌풍"
        case "sleet":
            currentWeatherCondition = "진눈깨비"
        case "snow":
            currentWeatherCondition = "눈"
        case "sunFlurries":
            currentWeatherCondition = "소낙눈"
        case "wintryMix":
            currentWeatherCondition = "눈, 비"
        case "blizzard":
            currentWeatherCondition = "눈보라"
        case "blowingSnow":
            currentWeatherCondition = "날린눈"
        case "freezingDrizzle":
            currentWeatherCondition = "언 진눈깨비"
        case "freezingRain":
            currentWeatherCondition = "얼어붙은 비"
        case "heavySnow":
            currentWeatherCondition = "폭설"
        case "hurricane":
            currentWeatherCondition = "허리케인"
        case "tropicalStorm":
            currentWeatherCondition = "열대 폭풍"
        default:
            break
        }
    }
}

class WeekWeatherTableViewCell: UITableViewCell {
    //주간 날씨 테이블뷰 ui
    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var weekWeatherMinTemp: UILabel!
    @IBOutlet weak var weekWeatherMaxTemp: UILabel!
    @IBOutlet weak var weekWeatherImage: UIImageView!
    @IBOutlet weak var tempProgressView: UIProgressView!
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    //테이블뷰 셀의 숫자
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    //테이블뷰 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weekWeatherTableView.dequeueReusableCell(withIdentifier: "WeekWeatherTableViewCell", for: indexPath) as! WeekWeatherTableViewCell
        cell.selectionStyle = .none
        //DateFormatter 생성
        let formatter = DateFormatter()
        //요일만 나오도록 설정
        formatter.dateFormat = "EEE"
        //오늘은 오늘이라고 설정하고 나머지는 요일로 나타내는 배열
        var weekDayArray: [String] = ["오늘"]
        for i in 1...9 {
            weekDayArray.insert(formatter.string(from: Date(timeIntervalSinceNow: 86400 * Double(i))), at: i)
        }
        //셀에 요일 넣기
        cell.weekDay.text = weekDayArray[indexPath.row]
        //최고, 최저 온도 및
        if self.weekWeatherMaxTempArray.count == 10, self.weekWeatherSymbolArray.count == 10 {
            cell.weekWeatherMaxTemp.text = "\(self.weekWeatherMaxTempArray[indexPath.row])º"
            cell.weekWeatherMinTemp.text = "\(self.weekWeatherMinTempArray[indexPath.row])º"
            cell.weekWeatherImage.image = UIImage(named: self.weekWeatherSymbolArray[indexPath.row])
            cell.tempProgressView.progress = 0.5 + Float((self.weekWeatherMaxTempArray[indexPath.row] + self.weekWeatherMinTempArray[indexPath.row])) / 100.0
        }
            
        return cell
    }
}