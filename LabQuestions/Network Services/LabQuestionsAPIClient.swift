//
//  LabQuestionsAPIClient.swift
//  LabQuestions
//
//  Created by Kelby Mittan on 12/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct LabQuestionsAPIClient {
    
    static func fetchQuestions(completion: @escaping (Result<[Question], AppError>) -> () ) {
        
        let labEndpointURLString = "https://5df04c1302b2d90014e1bd66.mockapi.io/questions"
        
        // create a url from the endpoint string
        
        guard let url = URL(string: labEndpointURLString) else {
            completion(.failure(.badURL(labEndpointURLString)))
            return
        }
        
        let request = URLRequest(url: url)
        
//        request.httpMethod = "GET"
//        request.httpBody = data
        
//        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let questions = try JSONDecoder().decode([Question].self, from: data)
                    completion(.success(questions))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
    }
    
    static func postQuestion(question: PostedQuestion, completion: @escaping (Result<Bool,AppError>) -> ()) {
        
        let endpointURLString = "https://5df04c1302b2d90014e1bd66.mockapi.io/questions"
        
        guard let url = URL(string: endpointURLString) else {
            completion(.failure(.badURL(endpointURLString)))
            return
        }
        
        do {
            let data = try JSONEncoder().encode(question)
            
            // configure our URLRequest
            var request = URLRequest(url: url)
            // type of http method
            request.httpMethod = "Post"
            // type of data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // provide data
            request.httpBody = data
            // execute POST request
            NetworkHelper.shared.performDataTask(with: request) { (result) in
                switch result {
                case .failure(let appError):
                    completion(.failure(.networkClientError(appError)))
                case .success:
                    completion(.success(true))
                }
            }
            
        } catch {
            completion(.failure(.encodingError(error)))
        }
        
    }
}
