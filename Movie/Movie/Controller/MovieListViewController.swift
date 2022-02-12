import UIKit

class MovieListViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var table: UITableView!
    
    
    var listCount : Int = 0
    var tempCount : Int = 10
    
    var minRating : String = ""
    var movieList = [Movie]()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addListTen(sender:)))
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func addListTen(sender: UIBarButtonItem){
        if tempCount <= listCount{
            tempCount = tempCount + 10
            if tempCount > listCount{
                tempCount = listCount
            }
        }
        self.table.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = self.storyboard?.instantiateViewController(identifier: "MovieDetailViewController") as? MovieDetailViewController else {return}
        detailVC.VCrating = self.movieList[indexPath.row].rating
        detailVC.VCtitle = self.movieList[indexPath.row].title
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tempCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        if indexPath.row > movieList.count - 1{
            return UITableViewCell()    // 아웃 오브 바운드 방지
        }
        else{
            
            let movie = movieList[indexPath.row]
            let cell = table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MovieCell
            
            if let rating = Double?(movie.rating!){ // optional(X.x) -> X.x로 변환 과정
                cell.movieRating.text = "\(rating)"
            }
            
            if cell.movieTitle.adjustsFontSizeToFitWidth == false{
                cell.movieTitle.adjustsFontSizeToFitWidth = true
            }
            
            cell.movieTitle.text = movie.title
            return cell
        }
    }
    
    
}
