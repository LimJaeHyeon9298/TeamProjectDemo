



import UIKit

class ViewController: UIViewController {
    //첫번째 뷰
    @IBOutlet weak var firstview: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    //작년 날씨 뷰
    @IBOutlet weak var LYtempView: UIView!
    @IBOutlet weak var LYWeatherImage: UIImageView!
    @IBOutlet weak var LYWeatherLabel: UILabel!
    @IBOutlet weak var LYtempMaxLabel: UILabel!
    @IBOutlet weak var LYtempMinLabel: UILabel!
    //캘린더 뷰
    @IBOutlet weak var calenderView: UIView!
    //기능 뷰
    @IBOutlet weak var otherOptionView: UIView!
    //지역 뷰
    @IBOutlet weak var regionView: UIView!
    @IBOutlet weak var regionLabel: UILabel!
    //오늘 날씨 뷰
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherTempLabel: UILabel!
    @IBOutlet weak var weatherDateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //view를 클릭 가능하도록 설정
        self.firstview.isUserInteractionEnabled = true
        //제쳐스 추가
        self.firstview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.firstViewTapped)))
    }
    
    func setupUI() {
        //view들 모서리 커브
        firstview.layer.cornerRadius = 15
        LYtempView.layer.cornerRadius = 15
        calenderView.layer.cornerRadius = 15
        otherOptionView.layer.cornerRadius = 15
        regionView.layer.cornerRadius = 15
        weatherView.layer.cornerRadius = 15
    }
    
    //첫번째 뷰를 눌렀을 때
    @objc func firstViewTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showFirstView", sender: nil)
    }
    
}

