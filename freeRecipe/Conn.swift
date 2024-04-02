import UIKit

public class Con: NSObject, ObservableObject, Codable {

    @Published var name: String?
    @Published var steps: [String]?
    @Published var ingredFirst: [String]?
    @Published var ingredSecond: [Int]?

    public override init() {
        super.init()
    }

    func initWithData(name: String, steps: [String], ingredFirst: [String], ingredSecond: [Int]) {
        self.name = name
        self.steps = steps
        self.ingredFirst = ingredFirst
        self.ingredSecond = ingredSecond
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case steps
        case ingredFirst
        case ingredSecond
    }

    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let steps = try container.decodeIfPresent([String].self, forKey: .steps)
        let ingredFirst = try container.decodeIfPresent([String].self, forKey: .ingredFirst)
        let ingredSecond = try container.decodeIfPresent([Int].self, forKey: .ingredSecond)

        self.init()
        self.initWithData(
            name: name ?? "",
            steps: steps ?? [],
            ingredFirst: ingredFirst ?? [],
            ingredSecond: ingredSecond ?? []
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(steps, forKey: .steps)
        try container.encode(ingredFirst, forKey: .ingredFirst)
        try container.encode(ingredSecond, forKey: .ingredSecond)
    }
}
