import ArgumentParser
import Foundation

@main
struct TriviaProfileCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "TriviaProfile",
        abstract: "Profile, import, export, and manage trivia question data",
        subcommands: [ReportCommand.self, ImportCommand.self, ExportCommand.self, CategoriesCommand.self, StatsCommand.self],
        defaultSubcommand: ReportCommand.self
    )
}
