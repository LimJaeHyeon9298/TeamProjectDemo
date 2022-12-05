



import UIKit

class CurrentWeatherViewController: UIViewController, UISearchBarDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        searchBar.delegate = self
    }
    
    func setupUI() {
        weatherView.layer.cornerRadius = 15
        searchBar.layer.cornerRadius = 15
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //검색시작
        
        //키보드가 올라와 있을 때, 내려가도록 설정
        dismissKeyboard()
        
        //검색어가 있는지 확인
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        print("검색어: \(searchTerm)")
    }
}
