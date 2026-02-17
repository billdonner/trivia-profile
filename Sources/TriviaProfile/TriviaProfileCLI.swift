import ArgumentParser
import Foundation

@main
struct TriviaProfileCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "TriviaProfile",
        abstract: "Profile and report on trivia question data files"
    )

    @Argument(help: "Path to JSON trivia data file")
    var file: String

    @Flag(name: .long, help: "Output as JSON")
    var json: Bool = false

    @Option(name: .long, help: "Show only a specific section: summary, categories, sources, difficulty, hints, length, answers")
    var section: String? = nil

    func run() throws {
        let path = (file as NSString).expandingTildeInPath
        let url = URL(fileURLWithPath: path)

        guard FileManager.default.fileExists(atPath: url.path) else {
            throw ProfileError.fileNotFound(file)
        }

        let attrs = try FileManager.default.attributesOfItem(atPath: url.path)
        let fileSize = (attrs[.size] as? Int) ?? 0

        let (questions, format, generated) = try DataLoader.load(from: url)

        let report = ReportGenerator.generate(
            from: questions,
            format: format,
            generated: generated,
            fileSize: fileSize
        )

        if json {
            print(JSONRenderer.render(report, section: section))
        } else {
            print(TextRenderer.render(report, section: section))
        }
    }
}
