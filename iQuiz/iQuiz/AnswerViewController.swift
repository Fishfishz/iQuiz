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
    public var correctAns: String! = nil
    public var fullData: [Quiz] = []
    public var url: String! = nil
    
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
            NSLog("type num is " + String(type))
            questionView.questionNum = self.questionNum
            questionView.scoreNum = self.scoreNum
            questionView.fullData = self.fullData
            questionView.url = self.url
        } else if let finishedView = segue.destination as? FinishViewController {
            finishedView.scoreNum = self.scoreNum
            finishedView.totalNum = self.totalNum
            finishedView.url = self.url
        } else if let mainView = segue.destination as? ViewController {
            mainView.defaultUrl = self.url
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if chosenAns == correctAns {
            indicator.text = "You got it right"
            scoreNum += 1
        } else {
            indicator.text = "You got it wrong"
        }
        question.text = questionContent
        answer.text = "The correct answer is : " + correctAns
        questionNum += 1
    }
    
}
