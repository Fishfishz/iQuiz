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
    public var questionNum: Int! = 0
    public var scoreNum: Int! = 0
    public var totalNum: Int! = 0
    public var selectedAns: String! = nil
    public var answerType: [String]! = nil

    let mathQuestions = ["1 + 1 = ", "1 * 1 = "]
    let marvelQuestions = ["How many infinity stone are there?"]
    let scienceQuestions = ["What is H20?"]
    let mathAns = [["1", "2", "3", "4"], ["1", "2", "3", "4"]]
    let marvelAns = [["2", "3", "4", "6"]]
    let scienceAns = [["Water", "Oxygen", "Oil", "Acid"]]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answerType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionAnsCell = self.tableView.dequeueReusableCell(withIdentifier: QuestionViewController.CELL_STYLE) as! QuestionAnsCell
        cell.ans?.text = answerType[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        selectedAns = answerType[didSelectRowAt.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        switch typeNum {
        case 1:
            question.text = marvelQuestions[questionNum]
            answerType = marvelAns[questionNum]
            totalNum = marvelQuestions.count
        case 2:
            question.text = scienceQuestions[questionNum]
            answerType = scienceAns[questionNum]
            totalNum = scienceQuestions.count
        default:
            question.text = mathQuestions[questionNum]
            answerType = mathAns[questionNum]
            totalNum = mathQuestions.count
        }
    }
    
    @IBAction func submitAns(_ sender: Any) {
        if selectedAns == nil {
            let controller = UIAlertController(title: "Something went wrong", message: "Please make a selection", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Go"), style: .default, handler: {
                _ in NSLog("ok")
            }))
            present(controller, animated: true, completion: {NSLog("ok")})
        } else {
            performSegue(withIdentifier: "toAns", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let view = segue.destination as? AnswerViewController
        view?.chosenAns = selectedAns
        view?.type = self.typeNum
        view?.questionContent = self.question.text
        view?.questionNum = self.questionNum
        view?.totalNum = self.totalNum
        view?.scoreNum = self.scoreNum
    }
}

