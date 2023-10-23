import Foundation

public struct Configuration: Hashable {
	public var disabledRules: Set<String>
	public var rules: [String: RuleConfiguration]

	public init(
		rules: [String: RuleConfiguration] = [:],
		disabledRules: Set<String> = Set()
	) {
		self.rules = rules
		self.disabledRules = disabledRules
	}
}

extension Configuration {
	public enum RuleConfiguration: Codable {
		case warning
		case error

		public init(from decoder: Decoder) throws {
			let container = try decoder.singleValueContainer()

			if let value = try? container.decode(String.self) {
				switch value {
				case "warning":
					self = .warning
					return
				case "error":
					self = .error
					return
				default:
					break
				}
			}

			throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "failed to decode rule configuration object"))
		}
	}
}

extension Configuration: Decodable {
	enum CodingKeys: CodingKey {
		/// Contains all the top-level well-defined keys used in a configuration file
		enum PredefinedKeys: String {
			case disabledRules = "disabled_rules"
		}

		case disabledRules
		case ruleIdentifier(String)

		init?(intValue: Int) {
			return nil
		}

		init?(stringValue: String) {
			switch stringValue {
			case PredefinedKeys.disabledRules.rawValue:
				self = .disabledRules
			default:
				self = .ruleIdentifier(stringValue)
			}
		}

		var stringValue: String {
			switch self {
			case .disabledRules:
				PredefinedKeys.disabledRules.rawValue
			case let .ruleIdentifier(value):
				value
			}
		}

		var intValue: Int? {
			return nil
		}
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.disabledRules = Set()

		var decodedRules = [String: RuleConfiguration]()

		for key in container.allKeys {
			switch key {
			case .disabledRules:
				self.disabledRules = try container.decode(Set<String>.self, forKey: key)
			case let .ruleIdentifier(name):
				let ruleConfig = try container.decode(RuleConfiguration.self, forKey: key)

				decodedRules[name] = ruleConfig
			}
		}

		self.rules = decodedRules
	}
}
