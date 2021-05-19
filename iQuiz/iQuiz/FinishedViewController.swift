//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Fishzz on 5/13/21.
//
import UIKit

class FinishViewController: UIViewController {
    public var scoreNum: Int! = nil
    public var totalNum: Int! = nil
    public var url: String! = nil
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "toStart", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? ViewController {
            view.defaultUrl = self.url
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if scoreNum == totalNum {
            result.text = "Perfect!"
        } else {
            result.text = "Almost!"
        }
        score.text = String(scoreNum) + " of " + String(totalNum) + " right"
    }
}
