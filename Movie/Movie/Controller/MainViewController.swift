
import UIKit
import SwiftUI

class MainViewController: UIViewController{
    
    private let dataQueue = DispatchQueue(label: "movieQueue", qos: .utility, attributes: .concurrent)
    
    let rate = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let page = [(39144/50)+1,(38913/50)+1,(38808/50)+1,(38058/50)+1,(35910/50)+1,(31333/50)+1,(22279/50)+1,(9287/50)+1,(1156/50)+1,(22/50)+1]
    
    
    var idx:Int = 0
    var movieList = [Movie]()
    @IBOutlet weak var minRating: UITextField!
    @IBOutlet weak var nextBtnOutlet: UIButton!
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.activeIndicator)
        nextBtnOutlet.addTarget(self, action: #selector(showIndicator(_:)), for: .touchDragInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        idx = 0
        movieList.removeAll()
        minRating.text = nil
        minRating.placeholder = "(0 ~ 9)"
        minRating.tintColor = .clear
        nextBtnOutlet.isEnabled = false
        activeIndicator.color = .blue
        self.view.bringSubviewToFront(self.activeIndicator)
        activeIndicator.stopAnimating()
        createPickerView()
        dismissPickerView()
    }
    
    @objc func showIndicator(_ sender: UIButton){
        self.activeIndicator.startAnimating()
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        minRating.inputView = pickerView
    }
    
    func dismissPickerView(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(chooseRank))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        minRating.inputAccessoryView = toolBar
    }
    
    @objc func chooseRank() {
        minRating.resignFirstResponder()
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        self.getMovie()
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieListViewController") as? MovieListViewController else {return}
        nextVC.minRating = self.minRating.text ?? ""
        for i in 0..<self.idx{
            nextVC.movieList.append(Movie(title: self.movieList[i].title, rating: self.movieList[i].rating))
        }
        nextVC.listCount = self.movieList.count
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func validataInputField(){
        self.nextBtnOutlet.isEnabled = !(self.minRating.text?.isEmpty ?? true)
    }
    private func getMovie(){
        let first = "https://yts.mx/api/v2/list_movies.json?minimum_rating="
        guard let second = minRating?.text else { return }
        let third = "&sort_by=rating&limit=50&page="
        var pageNum = 0
        for i in 0..<rate.count{
            if rate[i] == minRating.text{
                pageNum = page[i]
            }
        }
        
        for fourth in 1...pageNum{
            let url = first + second + third + "\(fourth)"
            print(url)
            self.getMovieDate(url: url, fourth: fourth)
            print(self.movieList.count)
            if pageNum == 1 {usleep(2000000)}
            else{usleep(800000)}
        }
    }
    
    private func getMovieDate(url:String, fourth: Int){
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {
            data, response, error in
            guard let data = data, error == nil else {
                print("에러 발생")
                return
            }
            var result: MovieResponse?
            do{
                result = try JSONDecoder().decode(MovieResponse.self, from: data)
            }
            catch{
                print("fail to convert. \(error.localizedDescription)")
            }
            self.idx += result?.data?.movies?.count ?? self.idx //index 설정
            guard let nowIndex = result?.data?.movies?.count else {return}
            print("getMovieDate에서 진행된 count입니다. : ", self.movieList.count, "page : ", fourth)
            for i in 0..<nowIndex{
                self.movieList.append(Movie(title: result?.data?.movies?[i].title, rating: result?.data?.movies?[i].rating))
            }
            
        }).resume()
    }
}

extension MainViewController :  UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rate.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rate[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        minRating.text = rate[row]
        self.validataInputField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
