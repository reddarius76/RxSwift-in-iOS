//
//  TaskListViewController.swift
//  Goodlist
//
//  Created by Oleg Krikun on 21.05.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class TaskListViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filtredTasks = [Task]()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Goodlist"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    private func filterTasks(by priority: Priority?) {
        guard let priority = priority else {
            filtredTasks = tasks.value
            updateTableView()
            return
        }
        
        tasks.map { tasks in
            return tasks.filter { $0.priority == priority }
        }.subscribe { [weak self] tasks in
            if let self = self {
                self.filtredTasks = tasks
                self.updateTableView()
            }
        } onError: { error in
            print(error.localizedDescription)
        } onCompleted: {
            print("onCompleted tasks")
        } onDisposed: {
            print("onDisposed tasks")
        }.disposed(by: disposeBag)
    }
    
    private func updateTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    @IBAction func priorityChanged(_ sender: UISegmentedControl) {
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        filterTasks(by: priority)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
              let addTaskVC = navController.viewControllers.first as? AddTaskViewController else { return }
        
        addTaskVC.taskSubjectObservable.subscribe { [weak self] task in
            if let self = self {
                let priority = Priority(rawValue: self.segmentedControl.selectedSegmentIndex - 1)
    
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                self.tasks.accept(existingTasks)
                self.filterTasks(by: priority)
            }
        } onError: { error in
            print(error.localizedDescription)
        } onCompleted: {
            print("onCompleted taskSubjectObservable")
        } onDisposed: {
            print("onDisposed taskSubjectObservable")
        }.disposed(by: disposeBag)

    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filtredTasks[indexPath.row].title
        return cell
    }
}

