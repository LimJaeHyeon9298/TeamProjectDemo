



import UIKit


class CurrentWeatherViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
    //가장 기본 뷰
    @IBOutlet weak var backgroundView: UIView!
    
    //searchBar
    @IBOutlet weak var searchBar: UISearchBar!
    //현재 날씨
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherRegionLabel: UILabel!
    @IBOutlet weak var weatherTempLabel: UILabel!
    @IBOutlet weak var weatherDateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherMaxTempLabel: UILabel!
    @IBOutlet weak var weatherMinTempLabel: UILabel!
    //페이지 컨트롤
    @IBOutlet weak var weatherPageControl: UIPageControl!
    //컬렉션뷰
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    //자외선 지수
    @IBOutlet weak var uvIndexView: UIView!
    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var uvIndexCateLabel: UILabel!
    
    //가시거리
    @IBOutlet weak var visibilityView: UIView!
    @IBOutlet weak var visibilityLabel: UILabel!
    
    //바람
    @IBOutlet weak var windView: UIView!
    
    //체감온도
    @IBOutlet weak var apparentTemperatureView: UIView!
    @IBOutlet weak var apparentTemperatureLabel: UILabel!
    
    //습도
    @IBOutlet weak var humidityView: UIView!
    @IBOutlet weak var humidityLabel: UILabel!
    
    //강수확률
    @IBOutlet weak var precipitationView: UIView!
    @IBOutlet weak var precipitationChanceLabel: UILabel!
    
    //테이블뷰
    @IBOutlet weak var weekWeatherTableView: UITableView!
    
    //시간당 온도
    var hourWeatherTempArray: [String] = []
    var hourWeatherSymbol: [String] = []
    //10일간 최고 최저 온도
    var weekWeatherMaxTempArray: [Int] = []
    var weekWeatherMinTempArray: [Int] = []
    var weekWeatherSymbolArray: [String] = []
    //오늘 온도, 최고 최저 온도, 심볼네임
    var currentWeatherTemp = ""
    var currentWeatherSymbol = ""
    var dailyWeatherMaxTemp = ""
    var dailyWeatherMinTemp = ""
    //가시거리
    var currentWeatherVisibility = ""
    //자외선 지수
    var currentWeatherUvIndex = ""
    //풍속, 풍향
    var currentWeatherWindSpeed = ""
    var currentWeatherWinddirection = ""
    //체감온도
    var currentWeatherApparentTemperature = ""
    //습도
    var currentWeatherHumidity = ""
    //강수량
    var precipitation = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //searchBar 델리게이트 설정
        searchBar.delegate = self
        //collectionView 델리게이트 설정
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        //테이블뷰 델리케이트 설정
        weekWeatherTableView.delegate = self
        weekWeatherTableView.dataSource = self
        
        //기본뷰 터치가 가능하도록 설정
        self.backgroundView.isUserInteractionEnabled = true
        //기본뷰 액션 추가
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backgroundViewTapped)))
        
        //날씨세팅
        setWeatherUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //view세팅
    func setupUI() {
        weatherView.layer.cornerRadius = 15
        searchBar.layer.cornerRadius = 15
        uvIndexView.layer.cornerRadius = 15
        visibilityView.layer.cornerRadius = 15
        windView.layer.cornerRadius = 15
        apparentTemperatureView.layer.cornerRadius = 15
        humidityView.layer.cornerRadius = 15
        precipitationView.layer.cornerRadius = 15
        
        //오늘 날짜 표시
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 d일 (E)"
        weatherDateLabel.text = formatter.string(from: Date())
        
        weatherRegionLabel.text = "서울"
    }
    
    //현재 온도 세팅
    private func setWeatherUI() {
        //현재 날씨 뷰 세팅
        weatherTempLabel.text = self.currentWeatherTemp
        weatherMaxTempLabel.text = self.dailyWeatherMaxTemp
        weatherMinTempLabel.text = self.dailyWeatherMinTemp
        weatherImage.image = UIImage(named: self.currentWeatherSymbol)
        
        uvIndexLabel.text = currentWeatherUvIndex
        visibilityLabel.text = currentWeatherVisibility
        apparentTemperatureLabel.text = currentWeatherApparentTemperature
        humidityLabel.text = currentWeatherHumidity
        precipitationChanceLabel.text = precipitation
        
        print("가시거리: \(currentWeatherVisibility)")
        print("자외선지수: \(currentWeatherUvIndex)")
        print("바람세기: \(currentWeatherWindSpeed)")
        print("바람방향: \(currentWeatherWinddirection)")
        print("체감온도: \(currentWeatherApparentTemperature)")
        print("습도: \(currentWeatherHumidity)")
        print("강수확률: \(precipitation)")
    }
    
    //back버튼을 눌렀을때
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    //기본뷰를 눌렀을때 키보드가 내려가도록 설정
    @objc func backgroundViewTapped() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //검색시작
        
        //키보드가 올라와 있을 때, 내려가도록 설정
        searchBar.resignFirstResponder()
        
        //검색어가 있는지 확인
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        print("검색어: \(searchTerm)")
    }
    //컬랙션뷰 셀 갯수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    //컬렉션뷰 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
        
        let currentHour = Calendar.current
        var hourArray: [String] = ["지금"]
        
        for i in 1...23 {
            hourArray.insert(String(currentHour.component(.hour, from: Date(timeIntervalSinceNow: 3600 * Double(i)))) + "시", at: i)
            //            simbalArray.insert(weather!.dailyForecast[i - 1].symbolName, at: i - 1)
        }
        
        cell.weatherCollectionDate.text = hourArray[indexPath.row]
        
        
        if self.hourWeatherTempArray.count == 24, self.hourWeatherSymbol.count == 24 {
            cell.weatherCollectionTemp.text = self.hourWeatherTempArray[indexPath.row]
            cell.weatherCollectionImage.image = UIImage(named: self.hourWeatherSymbol[indexPath.row])
        }
        
        return cell
    }
    //테이블뷰 셀 갯수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weekWeatherTableView.dequeueReusableCell(withIdentifier: "WeekWeatherTableViewCell", for: indexPath) as! WeekWeatherTableViewCell
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

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weatherCollectionImage: UIImageView!
    @IBOutlet weak var weatherCollectionDate: UILabel!
    @IBOutlet weak var weatherCollectionTemp: UILabel!
}

