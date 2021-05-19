//
//  ViewController.swift
//  iQuiz
//
//  Created by Fishzz on 5/7/21.
//

import UIKit

struct Question: Codable {
    let text: String
    let answer: String
    let answers: [String]
}

struct Quiz: Codable {
    let title: String
    let desc: String
    let questions: [Question]
}

class SampleCell : UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
}

class SubjectSource : NSObject, UITableViewDataSource {
    public var fullData:[Quiz] = []
    public var subjects:[String] = []
    public var descriptions:[String] = []
    public var images = ["math", "marvel", "science"]
    
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
    var data = SubjectSource();
    let actor = SubjectSelector();
    var defaultUrl = "http://tednewardsandbox.site44.com/questions.json"
    var urlInputField = UITextField()
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func setting(_ sender: UIBarButtonItem) {
        let controller = UIAlertController(title: "Settings", message: "Enter URL", preferredStyle: .alert)
        
        controller.addTextField { (textField: UITextField) in
            self.urlInputField = textField
            // read from application settings
            self.urlInputField.text = UserDefaults.standard.string(forKey: "url_preference")
        }
        
        controller.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        controller.addAction(UIAlertAction(title: NSLocalizedString("Check Now", comment: "ok"), style: .default, handler: {_ in
            if((self.urlInputField.text) != nil){
                // store settings
                UserDefaults.standard.setValue(self.urlInputField.text, forKey: "url_preference")
                self.fetch(urlInput: self.urlInputField.text!)
            }
        }))
        present(controller, animated: true, completion: {NSLog("complete setting")})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = data
        tableView.delegate = actor
        if (self.data.subjects.count == 0) {
            fetch(urlInput: defaultUrl)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let questionView = segue.destination as! QuestionViewController
        questionView.typeNum = tableView.indexPathForSelectedRow?.row
        questionView.fullData = self.data.fullData
        questionView.url = self.defaultUrl
    }
    
    func fetch(urlInput: String) {
        let url = URL(string: urlInput)
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "data.json"
        var filePath: URL! = nil
        
        if directory != nil {
            filePath = directory?.appendingPathComponent(fileName)
        } else {
            DispatchQueue.main.async {
                self.alert(msg: "Can not find your directory")
            }
        }
        
        if (url == nil) {
            DispatchQueue.main.async {
                self.alert(msg: "Invalid url")
            }
            return
        }
        
        if Reachability.isConnectedToNetwork() {
            let task = URLSession.shared.dataTask(with: url!) {
                data, response, error in
                if (data != nil && error == nil) {
                    do {
                        // decode the data from url
                        let decodedData = try JSONDecoder().decode([Quiz].self, from: data!)
                        self.data.fullData = []
                        self.data.subjects = []
                        self.data.descriptions = []
                        for quiz in decodedData {
                            self.data.fullData.append(quiz)
                            self.data.subjects.append(quiz.title)
                            self.data.descriptions.append(quiz.desc)
                        }
                        self.defaultUrl = urlInput
                        // save to local directory
                        do {
                            try data!.write(to: filePath!, options: Data.WritingOptions.atomic)
                        } catch {
                            DispatchQueue.main.async {
                                self.alert(msg: "Can not save your data from url")
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.alert(msg: "Can not parse the data from your url")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.alert(msg: "Invalid url")
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            task.resume()
        } else {
            DispatchQueue.main.async {
                self.alert(msg: "Internet Connection Failed!")
            }
            DispatchQueue.global(qos: .userInitiated).async {
                var data: Data? = nil
                do {
                    try data = Data(contentsOf: filePath!)
                } catch {
                    self.alert(msg: "Failed to read local data")
                }
                
                if data != nil && data!.count > 0 {
                    do {
                        let decodedData = try JSONDecoder().decode([Quiz].self, from: data!)
                        self.data.subjects = []
                        self.data.descriptions = []
                        self.data.fullData = []
                        for quiz in decodedData {
                            self.data.fullData.append(quiz)
                            self.data.subjects.append(quiz.title)
                            self.data.descriptions.append(quiz.desc)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.alert(msg: "Can not parse your local data")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.alert(msg: "Can not find any data source")
                    }
                }
            }
        }
    }
    
    func alert(msg: String) {
        let controller = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "ok"), style: .default, handler: {
            _ in NSLog("ok")
        }))
        present(controller, animated: true, completion: {NSLog("ok")})
    }
}

