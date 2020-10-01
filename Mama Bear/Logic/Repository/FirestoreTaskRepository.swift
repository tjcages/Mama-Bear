//
//  FirestoreTaskRepository.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift

import Resolver
import Combine

class BaseTaskRepository {
    @Published var tasks = [Task]()
}

protocol TaskRepository: BaseTaskRepository {
    func addTask(_ task: Task)
    func removeTask(_ task: Task)
    func updateTask(_ task: Task)
}

class FirestoreTaskRepository: BaseTaskRepository, TaskRepository, ObservableObject {
    var database = Firestore.firestore()
    @Injected var authenticationService: AuthenticationService

    var tasksPath: String = "tasks"
    var userId: String = "unknown"

    private var listenerRegistration: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()

        authenticationService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)

        // Reload data if user changes
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink { user in
                self.loadData()
            }
            .store(in: &cancellables)
    }

    private func loadData() {
        // Pull data from Firestore
        // Organize data based on 'createdTime' <- will need update
        if listenerRegistration != nil {
            listenerRegistration?.remove()
        }
        listenerRegistration = database.collection(tasksPath)
            .whereField("userId", isEqualTo: self.userId)
            .order(by: "createdTime")
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.tasks = querySnapshot.documents.compactMap { document -> Task? in
                        try? document.data(as: Task.self)
                    }
                }
        }
    }

    func addTask(_ task: Task) {
        do {
            var userTask = task
            userTask.userId = self.userId
            userTask.updatedTime = nil
            let _ = try database.collection(tasksPath).addDocument(from: userTask)
        }
        catch {
            print("There was an error while trying to save a task: \(error.localizedDescription).")
        }
    }

    func removeTask(_ task: Task) {
        if let taskID = task.id {
            database.collection(tasksPath).document(taskID).delete { (error) in
                if let error = error {
                    print("Error removing document: \(error.localizedDescription).")
                }
            }
        }
    }

    func updateTask(_ task: Task) {
        if let taskID = task.id {
            do {
                var updatedTask = task
                updatedTask.updatedTime = nil
                try database.collection(tasksPath).document(taskID).setData(from: updatedTask)
            }
            catch {
                print("There was an error while trying to update a task: \(error.localizedDescription).")
            }
        }
    }

}
