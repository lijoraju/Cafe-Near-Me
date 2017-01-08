//
//  GCDBlackBox.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 08/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import Foundation

func performUIUpdateOnMain(updates: @escaping ()-> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
