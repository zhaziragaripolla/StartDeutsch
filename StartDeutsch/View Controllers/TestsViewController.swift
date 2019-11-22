//
//  TestsViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class TestsViewController: UIViewController {
    
    var viewModel: TestsViewModel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TestsViewModel()
        title = "Tests"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .white
        
        viewModel.delegate = self
        viewModel.getTestsForCourse(index: 0)
        
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
               if segue.identifier == "questionsVC",
                   let destinationVC = segue.destination as? QuestionsViewController {
                        let vm = QuestionsViewModel()
                        vm.testRef = viewModel.tests.first
                        destinationVC.viewModel = vm
               }
           }
    

}

extension TestsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.tests.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Test \(indexPath.row+1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vm = viewModel.getQuestionsViewModel(index: indexPath.row)
//        let vc = QuestionsViewController()
//        vc.viewModel = vm
//        self.navigationController?.pushViewController(vc, animated: true)
        
        performSegue(withIdentifier: "questionsVC", sender: nil)
    }
    
}

extension TestsViewController: TestsViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
    
}
