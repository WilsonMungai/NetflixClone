//
//  DataPersistenceManager.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-23.
//

// responsible for accessing core data
import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    enum DataBaseError: Error {
        case failedToSaveData
        case failedToRetrieveData
        case failedToDeleteData
    }
    // singleton
    static let shared = DataPersistenceManager()
    
    // dowmlaoding movie of type Title from the cell
    // completion handler to notify when there changes
    /// Method responsible stroing data in the core data
    /// - Parameters:
    ///   - model: reference of model Title
    ///   - completion: notify when there are changes
    func downloadTitle(with model: Title, completion: @escaping (Result<Void, Error>)-> Void) {
        
        // instance/reference to app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // property to hold database
        let context  = appDelegate.persistentContainer.viewContext
        
        // item being store in database
        let item = TitleItem(context: context)
        
        // assigning databse attributes to the model attributes
        item.id = Int64(model.id)
        item.title = model.title
        item.original_title = model.original_title
        item.poster_path = model.poster_path
        item.overview = model.overview
        item.release_date = model.release_date
        item.media_type = model.media_type
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        // saves unsaved changes to the context
        do {
            // success
            try context.save()
            // pass completion when the data has been saved
            // it expects void so just pass empty brackets
            completion(.success(()))
            // error
        } catch {
            completion(.failure(DataBaseError.failedToSaveData))
        }
    }
    
    // fetching the data
    // when this function is called it will return an arrey of the objects saved in coredata or an error
    func fetchingTitlesFromDatabase(completion: @escaping (Result<[TitleItem], Error>)-> Void) {
        // instance/reference to app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // property to hold database
        let context  = appDelegate.persistentContainer.viewContext
        
        // make request to fetch the data
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            // asking the context to request the data from the database with my request of the title items
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DataBaseError.failedToRetrieveData))
        }
    }
    
    // delete method
    func deletetitle(model: TitleItem, completion: @escaping (Result<Void, Error>) -> Void) {
        // instance/reference to app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // property to hold database
        let context  = appDelegate.persistentContainer.viewContext
        
        // asking context to delete item
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToDeleteData))
        }
    }
}
