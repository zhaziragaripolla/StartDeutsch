//
//  CourseListViewController.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/18/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit
import MessageUI

class CourseListViewController: UIViewController {
    
    // View model
    private var viewModel: CourseListViewModel!
    
    // Delegates
    weak var delegate: CourseListViewControllerDelegate?
    
    // UI
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var headerView = UIView()
    private var helpBarItem: UIBarButtonItem!
    private var tableViewHeaderHeight: CGFloat = {
        return UIScreen.main.bounds.height * 0.35
    }()
    let headerTitles = ["Courses"]
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    init(viewModel: CourseListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupUI() {
        
        view.backgroundColor = .white
        title = "Start Deutsch"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Help button
        helpBarItem = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(didTapHelpButton(_:)))
        self.navigationItem.setRightBarButton(helpBarItem, animated: true)
        
        // Header's image view
        headerView.addSubview(imageView)
        imageView.snp.makeConstraints{ make in
            make.width.equalToSuperview().multipliedBy(0.65)
            make.height.equalToSuperview().multipliedBy(0.65)
            make.center.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        imageView.image = UIImage(named: "background.png")
        
        // Table view
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: tableViewHeaderHeight , left: 0, bottom: 30, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableViewHeaderHeight)
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CourseTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI configuration
        setupUI()
        updateHeaderView()
        
        // View model configuration
        viewModel.delegate = self
        viewModel.errorDelegate = self
        viewModel.getCourses()
    }

    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -tableViewHeaderHeight, width: tableView.bounds.width, height: tableViewHeaderHeight)
        if tableView.contentOffset.y < -tableViewHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }

}

extension CourseListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.courses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CourseTableViewCell
        let course = viewModel.courses[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.configure(course: course)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = viewModel.courses[indexPath.row]
        delegate?.didSelectCourse(course: course)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension CourseListViewController: ViewModelDelegate, ErrorDelegate {

    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func didDownloadData() {
        tableView.reloadData()
    }
    
}

extension CourseListViewController: MFMailComposeViewControllerDelegate{
    @objc func didTapHelpButton(_ sender: UIButton) {
        // Modify following variables with your text / recipient
        let recipientEmail = "help.startdeutsch@gmail.com"
        var body: String = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            body.append("App Version: \(version)\n")
        }
        
        let os = ProcessInfo().operatingSystemVersion
        let osVersionString = "\(os.majorVersion.description).\(os.minorVersion.description).\(os.patchVersion.description)"
        body.append("Device iOS version: \(osVersionString)\n")
        body.append("Model: \(modelIdentifier())")
        
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setMessageBody(body, isHTML: false)
            present(mail, animated: true)
        }
//        else if let emailUrl = createEmailUrl(to: recipientEmail, subject: "", body: body) {
//            UIApplication.shared.open(emailUrl)
//        }
        else {
             UIApplication.shared.open(URL(string: "https://startdeutschapp.wixsite.com/startdeutsch")!, options: [:], completionHandler: nil)
        }
    }
    
    func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        }
        
        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
