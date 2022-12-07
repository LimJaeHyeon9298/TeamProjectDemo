



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
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    
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
    }
    //view세팅
    func setupUI() {
        weatherView.layer.cornerRadius = 15
        searchBar.layer.cornerRadius = 15
        
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
        return 27
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
        
        return cell
    }
}
