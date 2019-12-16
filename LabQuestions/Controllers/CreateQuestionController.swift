//
//  CreateQuestionController.swift
//  LabQuestions
//
//  Created by Alex Paul on 12/11/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class CreateQuestionController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var questionTextView: UITextView!
    @IBOutlet var labPickerView: UIPickerView!
    
    private let labs = ["Concurrency", "Comic", "Parsing JSON - Weather, Color, User", "Image and Error Handling", "StocksPeople", "Intro to Unit Testing - Jokes, Star Wars, Trivia"].sorted()
    
    // labName will be the current selected row in the picker view
    private var labName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labPickerView.dataSource = self
        labPickerView.delegate = self
        
        labName = labs.first
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        questionTextView.layer.borderColor = UIColor.systemGray.cgColor
        questionTextView.layer.borderWidth = 2
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func createQuestion(_ sender: UIBarButtonItem) {
        
        // 3 required parameters to create a Question
        guard let questionTitle = titleTextField.text,
            !questionTitle.isEmpty,
            let labName = labName,
            let labDescription = questionTextView.text else {
                showAlert(title: "Missing Fields", message: "Title, Description are required")
                return
        }
        
        let question = PostedQuestion(title: questionTitle, labName: labName, description: labDescription, createdAt: String.getISOTimestamp())
        
        // POST Question using API Client
        LabQuestionsAPIClient.postQuestion(question: question) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error posting question", message: "\(appError)")
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Success", message: "\(questionTitle) was posted")
                }
            }
        }
    }
}

extension CreateQuestionController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return labs.count
    }
}

extension CreateQuestionController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return labs[row]
    }
}
