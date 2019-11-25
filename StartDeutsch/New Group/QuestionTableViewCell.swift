//
//  QuestionTableViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/21/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import AVFoundation

protocol ListeningTableViewCellDelegate: class {
    func indexOfSelectedButton(index: Int, cell: UITableViewCell)
}

class QuestionTableViewCell: UITableViewCell{
    
    weak var delegate: ListeningTableViewCellDelegate?
    var audioFile : AVAudioFile!
    var audioPlayer = AVAudioPlayer()
    var url: URL!
    
    @IBOutlet weak var firstAnswerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var secondAnswerLabel: UILabel!
    
    @IBOutlet weak var thirdAnswerLabel: UILabel!
    
    @IBAction func didTapPlayButton(_ sender: Any) {
        setupAudio()
    }
    
    @IBAction func didTapFirstButton(_ sender: UIButton) {
//        print("tag ", sender.tag)
        delegate?.indexOfSelectedButton(index: sender.tag, cell: self)
    }
    
    @IBAction func didTapSecondButton(_ sender: UIButton) {
//        print("tag ", sender.tag)
        delegate?.indexOfSelectedButton(index: sender.tag, cell: self)
    }
    
    @IBAction func didTapThirdBUTTON(_ sender: UIButton) {
//        print("tag ", sender.tag)
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

class BinaryQuestionTableViewCell: UITableViewCell {
//    var questionLabel: UILabel!
    
    var url: URL!
    
    var audioPlayer = AVAudioPlayer()
    weak var delegate: ListeningTableViewCellDelegate?
//    var url: URL!
    
    @IBOutlet weak var questionLabel: UILabel!
   
    @IBAction func didTapFalseButton(_ sender: Any) {
        delegate?.indexOfSelectedButton(index: 0, cell: self)
    }
    
    @IBAction func didTapTrueButton(_ sender: Any) {
        delegate?.indexOfSelectedButton(index: 1, cell: self)
    }
    
    @IBAction func didTapAudioButton(_ sender: Any) {
        setupAudio()
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
