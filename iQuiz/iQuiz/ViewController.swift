//
//  ViewController.swift
//  iQuiz
//
//  Created by Fishzz on 5/7/21.
//

import UIKit

class SampleCell : UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
}

class SubjectSource : NSObject, UITableViewDataSource {
    let subjects = ["Mathematics", "Marvel Super Heroes", "Science"]
    let descriptions = ["Algebra, Calculus, Geometry", "Iron man, The Hulk", "Biology, Physics, Chemistry"]
    let images = ["math", "marvel", "science"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SampleCell = tableView.dequeueReusableCell(withIdentifier: ViewController.CELL_STYLE, for: indexPath) as! SampleCell
    
        cell.desc?.text = descriptions[indexPath.row]
        cell.icon?.image = UIImage(named: images[indexPath.row])
        cell.title?.text = subjects[indexPath.row]
        return cell
        
    }
}

class SubjectSelector: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

class ViewController: UIViewController {
    static let CELL_STYLE = "quizCell"
    let data = SubjectSource();
    let actor = SubjectSelector();
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func setting(_ sender: UIBarButtonItem) {
        let controller = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Good"), style: .default, handler: {
            _ in NSLog("ok")
        }))
        present(controller, animated: true, completion: {NSLog("ok")})
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = data
        tableView.delegate = actor
    }
}

