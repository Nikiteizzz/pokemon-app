//
//  CustomizedNavigationController.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 23.10.22.
//

import UIKit

//Нужен для того, чтобы сделать статус бар чёрного цвета во всём приложении

class CustomizedNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
