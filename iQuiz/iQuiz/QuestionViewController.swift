//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Fishzz on 5/13/21.
//
import UIKit

class QuestionAnsCell: UITableViewCell {
    @IBOutlet weak var ans: UILabel!
}

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var question: UILabel!
    public var typeNum: Int! = 0
    static let CELL_STYLE = "questionAnsCell"
    public var fullData: [Quiz] = []
    public var questionNum: Int! = 0
    public var scoreNum: Int! = 0
    public var totalNum: Int! = 0
    public var selectedAns: String! = nil
    public var answers: [String]! = nil
    public var correctAns: String? = nil
    public var url: String! = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionAnsCell = self.tableView.dequeueReusableCell(withIdentifier: QuestionViewController.CELL_STYLE) as! QuestionAnsCell
        cell.ans?.text = answers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        selectedAns = answers[didSelectRowAt.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let subject = fullData[typeNum]
        answers = subject.questions[questionNum].answers
        totalNum = subject.questions.count
        self.question.text = subject.questions[questionNum].text
        self.correctAns = self.answers[Int(subject.questions[questionNum].answer)! - 1]
    }
    
    @IBAction func submitAns(_ sender: Any) {
        if selectedAns == nil {
            let controller = UIAlertController(title: "Error", message: "Please make a selection", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "ok"), style: .default, handler: {
                _ in NSLog("ok")
            }))
            present(controller, animated: true, completion: {NSLog("ok")})
        } else {
            performSegue(withIdentifier: "toAns", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? AnswerViewController {
            view.chosenAns = selectedAns
            view.type = self.typeNum
            view.questionContent = self.question.text
            view.questionNum = self.questionNum
            view.totalNum = self.totalNum
            view.scoreNum = self.scoreNum
            view.correctAns = self.correctAns
            view.fullData = self.fullData
            view.url = self.url
        }
        
        if let view = segue.destination as? ViewController {
            view.defaultUrl = url
        }
    }
}

