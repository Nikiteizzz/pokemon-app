//
//  CustomizedNavigationController.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 23.10.22.
//

import UIKit

//Needed to make status bar black in app
class CustomizedNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
