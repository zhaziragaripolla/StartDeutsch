//
//  ViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/18/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SwiftCSV

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let courses: [String] = ["Hören", "Lesen", "Schreiben", "Sprechen"]
    
    var viewModel: CoursesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Start Deutsch A1"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        viewModel = CoursesViewModel()
        tableView.reloadData()
        
//        if let url = Bundle.main.url(forResource: "listening1-5", withExtension: "csv") {
//            if let csvFile: CSV = try? CSV(url: url) {
//                print(csvFile.enumeratedRows)
//                csvFile.enumeratedRows.forEach({
//                    if $0[0].toBool()!{
//                        // is Multiple choice
//                        let question = ListeningQuestion(question: $0[2], answer: Int($0[6])!, number: Int($0[1])!, choices: [$0[3], $0[4], $0[5]], isMultipleChoice: true)
//                        viewModel.save(question: question)
//                    }
//                    else {
//                        // true/false question
//                        let question = ListeningQuestion(question: $0[2], answer: Int($0[6])!, number: Int($0[1])!, choices: nil, isMultipleChoice: false)
//                        viewModel.save(question: question)
//                    }
//
//                })
//            }
//        }
//        else {
//            print("Error")
//        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "testsVC",
               let destinationVC = segue.destination as? TestsViewController {
//                   destinationVC.numberToDisplay = counter
           }
       }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let course = courses[indexPath.row]
        cell.textLabel?.text = course
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let course = courses[indexPath.row]
//        viewModel.getTestsForCourse(index: indexPath.row, completion: { vm in
//            if let vm = vm {
//                let vc = TestsViewController()
//                vc.viewModel = vm
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//
//        })
//        let vc = storyboard?.instantiateViewController(identifier: "TestsViewController") as! TestsViewController
        performSegue(withIdentifier: "testsVC", sender: nil)
//            let vc = TestsViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}
