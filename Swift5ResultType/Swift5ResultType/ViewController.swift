//
//  ViewController.swift
//  Swift5ResultType
//
//  Created by Hasan on 10/01/2020.
//  Copyright © 2020 Hasan. All rights reserved.
//

import UIKit

struct Course: Decodable {
    let id: Int
    let name: String
    let imageUrl: String
    let number_of_lessons: Int
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //swift 5 result type
        fetchCoursesJSON { (result) in
            switch result {
            case .failure(let error):
                print("failed to fetch courses", error)
            case .success(let courses):
                courses.forEach { course in
                    print(course.name)
                }
            }
        }

        //before swift 5
//        fetchCoursesJSON { (courses, error) in
//            //ambiguous situation here
//            if let err = error {
//                print("failed to fetch courses")
//                return
//            }
//
//            courses?.forEach({ (course) in
//                print(course.name)
//            })
//        }
        
    }

    //result type swift 5
    func fetchCoursesJSON(completion: @escaping (Result<[Course], Error>) -> ()) {
        let urlString = "https://api.letsbuildthatapp.com/jsondecodable/courses"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            //successful
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data!)
                completion(.success(courses))
            } catch let jsonError {
                completion(.failure(jsonError))
            }

        }.resume()
    }


    // Before Swift 5
//    func fetchCoursesJSON(completion: @escaping ([Course]?, Error?) -> ()) {
//        let urlString = "https://api.letsbuildthatapp.com/jsondecodable/courses"
//        guard let url = URL(string: urlString) else { return }
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//
//            //successful
//            do {
//                let courses = try JSONDecoder().decode([Course].self, from: data!)
//                completion(courses, nil)
//            } catch let jsonError {
//                completion(nil, jsonError)
//            }
//
//        }.resume()
//    }
}

