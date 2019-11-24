//
//  QuestionTableViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/21/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import AVFoundation

protocol QuestionTableViewCellDelegate: class {
    func indexOfSelectedButton(index: Int, cell: UITableViewCell)
}

class QuestionTableViewCell: UITableViewCell {
    
    weak var delegate: QuestionTableViewCellDelegate?
    var audioFile : AVAudioFile!
    var audioPlayer = AVAudioPlayer()
//    var audioPlayerNode : AVAudioPlayerNode!
    var url: URL!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBAction func didTapPlayButton(_ sender: Any) {
        setupAudio()
    }
    
    @IBAction func didTapFirstButton(_ sender: UIButton) {
        print("tag ", sender.tag)
        delegate?.indexOfSelectedButton(index: sender.tag, cell: self)
    }
    
    @IBAction func didTapSecondButton(_ sender: UIButton) {
        print("tag ", sender.tag)
        delegate?.indexOfSelectedButton(index: sender.tag, cell: self)
    }
    
    @IBAction func didTapThirdBUTTON(_ sender: UIButton) {
        print("tag ", sender.tag)
        delegate?.indexOfSelectedButton(index: sender.tag, cell: self)
    }
    
    //    var questionsLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        return label
//    }()
//
//    var choiceButton: UIButton = {
//
//    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupAudio() {
           // initialize (recording) audio file
           do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.play()
           } catch {
                print(error)
           }
    }
    

}
