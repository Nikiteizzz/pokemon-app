//
//  CoreDataManager.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 27.10.22.
//

import Foundation
import UIKit
import CoreData

protocol CoreDataManagerProtocol: AnyObject {
    func getContext() -> NSManagedObjectContext
    func getEntityObj() -> PokemonSave
    func savePokemon(resultHandler: (Result<String, Error>) -> Void)
}

class CoreDataManager: CoreDataManagerProtocol {
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func getEntityObj() -> PokemonSave {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "PokemonSave", in: context)
        let pokemon = PokemonSave(entity: entity!, insertInto: context)
        return pokemon
    }
    
    func savePokemon(resultHandler: (Result<String, Error>) -> Void) {
        let context = getContext()
        do {
            try context.save()
            resultHandler(.success("Successfully saved"))
        } catch let error {
            resultHandler(.failure(error))
        }
    }
}
