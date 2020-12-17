//
//  SpellingInstaller.swift
//  Milonchik
//
//  Created by Roey Biran on 17/12/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Foundation

struct SpellingInstaller {
    func install() throws {
        let fm = FileManager.default
        guard let library = fm.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            throw MilonchikError.HebrewSpellingInstallerError.spellingDirectoryAccessFailure
        }
        let spellingDirectory = library.appendingPathComponent("Spelling", isDirectory: true)
        let files: [(name: String, ext: String)] = [("he_IL", "aff"), ("he_IL", "dic")]
        try files.forEach({ file in
            let dst = spellingDirectory.appendingPathComponent(file.name).appendingPathExtension(file.ext)
            if fm.fileExists(atPath: dst.path) { return }
            let src = Bundle.main.url(forResource: file.name, withExtension: file.ext)!
            do {
                try fm.createDirectory(at: spellingDirectory, withIntermediateDirectories: true)
                try fm.copyItem(at: src, to: dst)
            } catch let error as CocoaError where error.code == CocoaError.fileWriteFileExists {
                return
            } catch {
                throw error
            }
        })
    }
}
