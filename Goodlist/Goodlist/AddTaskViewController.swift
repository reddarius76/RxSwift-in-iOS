//
//  AddTaskViewController.swift
//  Goodlist
//
//  Created by Oleg Krikun on 21.05.2021.
//

import UIKit
import RxSwift

final class AddTaskViewController: UIViewController {
    
    private let taskSubject = PublishSubject<Task>()
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObserver()
    }

    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var taskTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Task"
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let priority = Priority(rawValue: prioritySegmentedControl.selectedSegmentIndex),
              let title = taskTextField.text else { return }
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        
        dismiss(animated: true, completion: nil)
    }
}
