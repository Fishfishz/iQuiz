//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Fishzz on 5/13/21.
//
import UIKit

class AnswerViewController: UIViewController {
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var indicator: UILabel!
    public var chosenAns: String! = nil
    public var type: Int! = nil
    public var questionNum: Int! = nil
    public var totalNum: Int! = nil
    public var scoreNum: Int! = nil
    public var questionContent: String! = nil
    let correctAns = [["2", "1"], ["6"], ["Water"]]
    
    @IBAction func next(_ sender: Any) {
        if (questionNum == totalNum) {
            performSegue(withIdentifier: "toFinished", sender: self)
        } else {
            performSegue(withIdentifier: "toQues", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let questionView = segue.destination as? QuestionViewController {
            questionView.typeNum = self.type
            questionView.questionNum = self.questionNum
            questionView.scoreNum = self.scoreNum
        } else if let finishedView = segue.destination as? FinishViewController {
            finishedView.scoreNum = self.scoreNum
            finishedView.totalNum = self.totalNum
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if chosenAns == correctAns[type][questionNum] {
            indicator.text = "You got it right"
            scoreNum += 1
        } else {
            indicator.text = "You got it wrong"
        }
        question.text = questionContent
        answer.text = "The correct answer is : " + correctAns[type][questionNum]
        questionNum += 1
    }
    
}
