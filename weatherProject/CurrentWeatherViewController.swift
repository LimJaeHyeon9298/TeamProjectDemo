



import UIKit


class CurrentWeatherViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    //시간당 온도
    var hourWeatherTempArray: [String] = []
    var hourWeatherSymbol: [String] = []
    //10일간 최고 최저 온도
    var weekWeatherMaxTempArray: [String] = []
    var weekWeatherMinTempArray: [String] = []
    var weekWeatherSymbolArray: [String] = []
    //오늘 온도, 최고 최저 온도, 심볼네임
    var currentWeatherTemp = ""
    var currentWeatherSymbol = ""
    var dailyWeatherMaxTemp = ""
    var dailyWeatherMinTemp = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //searchBar 델리게이트 설정
        searchBar.delegate = self
        //collectionView 델리게이트 설정
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        
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
        
        //오늘 날짜 표시
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 d일 (E)"
        weatherDateLabel.text = formatter.string(from: Date())
        
        weatherRegionLabel.text = "서울"
    }
    
    //현재 온도 세팅
    private func setWeatherUI() {
        weatherTempLabel.text = self.currentWeatherTemp
        weatherMaxTempLabel.text = self.dailyWeatherMaxTemp
        weatherMinTempLabel.text = self.dailyWeatherMinTemp
        weatherImage.image = UIImage(named: self.currentWeatherSymbol)
        print(self.currentWeatherTemp)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
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
}
