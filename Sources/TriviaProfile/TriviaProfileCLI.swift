import ArgumentParser
import Foundation

@main
struct TriviaProfileCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "TriviaProfile",
        abstract: "Profile and report on trivia question data files"
    )

    @Argument(help: "Path(s) to JSON trivia data file(s)")
    var files: [String]

    @Flag(name: .long, help: "Output as JSON")
    var json: Bool = false

    @Option(name: .long, help: "Show only a specific section: summary, categories, sources, difficulty, hints, length, answers")
    var section: String? = nil

    func run() throws {
        var allQuestions: [ProfiledQuestion] = []
        var totalFileSize = 0
        var fileDetails: [ReportData.FileDetail] = []
        var latestGenerated: Date? = nil
        var hasDifficulty = false

        for filePath in files {
            let path = (filePath as NSString).expandingTildeInPath
            let url = URL(fileURLWithPath: path)

            guard FileManager.default.fileExists(atPath: url.path) else {
                throw ProfileError.fileNotFound(filePath)
            }

            let attrs = try FileManager.default.attributesOfItem(atPath: url.path)
            let fileSize = (attrs[.size] as? Int) ?? 0
            totalFileSize += fileSize

            let (questions, format, generated) = try DataLoader.load(from: url)
            allQuestions.append(contentsOf: questions)

            if format == .raw { hasDifficulty = true }

            let sizeStr = ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
            let formatStr = format == .gameData ? "Game Data" : "Raw"
            fileDetails.append(.init(
                name: url.lastPathComponent,
                questionCount: questions.count,
                fileSize: sizeStr,
                format: formatStr
            ))

            if let generated {
                if latestGenerated == nil || generated > latestGenerated! {
                    latestGenerated = generated
                }
            }
        }

        let report = ReportGenerator.generate(
            from: allQuestions,
            fileDetails: fileDetails,
            totalFileSize: totalFileSize,
            generated: latestGenerated,
            hasDifficulty: hasDifficulty
        )

        if json {
            print(JSONRenderer.render(report, section: section))
        } else {
            print(TextRenderer.render(report, section: section))
        }
    }
}
