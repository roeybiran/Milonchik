import Foundation

struct SpellingInstaller {
    func install(using fileManager: FileManager = .default, bundle: Bundle = .main) throws {
        guard let library = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            throw MilonchikError.HebrewSpellingInstallerError.spellingDirectoryAccessFailure
        }
        let spellingDirectory = library.appendingPathComponent("Spelling", isDirectory: true)
        let files: [(name: String, ext: String)] = [("he_IL", "aff"), ("he_IL", "dic")]
        try files.forEach { file in
            let dst = spellingDirectory.appendingPathComponent(file.name).appendingPathExtension(file.ext)
            if fileManager.fileExists(atPath: dst.path) { return }
            guard let src = bundle.url(forResource: file.name, withExtension: file.ext) else {
                preconditionFailure("Spelling dictionaries within bundle are missing or corrupt")
            }
            do {
                try fileManager.createDirectory(at: spellingDirectory, withIntermediateDirectories: true)
                try fileManager.copyItem(at: src, to: dst)
            } catch let error as CocoaError where error.code == CocoaError.fileWriteFileExists {
                return
            } catch {
                throw error
            }
        }
    }
}
