//
//  IVRFileWriter.swift
//  PDToolbox
//
//  Created by Dquavius Griffin on 5/24/22.
//

import Foundation

protocol IVRFileWriter {
    func write(menus: [IVRMenu], toPath: URL)
}
