import Foundation

// Local persistence for fields not provided by the external API

struct ClientExtras: Codable {
    var numeroTva: String?
}

struct FormateurExtras: Codable {
    var exterieur: Bool?
    var societe: String?
    var siret: String?
    var nda: String?
}

struct SessionExtras: Codable {
    // modalite: "P" or "D"
    var modalite: String?
    var lieu: String?
    var tarifSousTraitant: Double?
    var fraisRembourser: Double?
    var refContrat: String?
}

private struct ExtrasDiskModel: Codable {
    var clients: [String: ClientExtras] = [:]   // key: id as String
    var formateurs: [String: FormateurExtras] = [:]
    var sessions: [String: SessionExtras] = [:]
}

final class ExtrasStore {
    static let shared = ExtrasStore()
    private let queue = DispatchQueue(label: "extras.store.queue")
    private var cache = ExtrasDiskModel()
    private let fileURL: URL

    private init() {
        let fm = FileManager.default
        let base = (try? fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)) ?? fm.temporaryDirectory
        let dir = base.appendingPathComponent("LearnTrack", isDirectory: true)
        if !fm.fileExists(atPath: dir.path) {
            try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        fileURL = dir.appendingPathComponent("extras.json")
        load()
    }

    private func load() {
        queue.sync {
            guard let data = try? Data(contentsOf: fileURL) else { return }
            if let decoded = try? JSONDecoder().decode(ExtrasDiskModel.self, from: data) {
                self.cache = decoded
            }
        }
    }

    private func save() {
        queue.async {
            if let data = try? JSONEncoder().encode(self.cache) {
                try? data.write(to: self.fileURL, options: [.atomic])
            }
        }
    }

    // MARK: - Client
    func getClientExtras(id: Int64) -> ClientExtras? {
        queue.sync { cache.clients[String(id)] }
    }

    func setClientExtras(id: Int64, _ extras: ClientExtras?) {
        queue.sync {
            cache.clients[String(id)] = extras
        }
        save()
    }

    // MARK: - Formateur
    func getFormateurExtras(id: Int64) -> FormateurExtras? {
        queue.sync { cache.formateurs[String(id)] }
    }

    func setFormateurExtras(id: Int64, _ extras: FormateurExtras?) {
        queue.sync {
            cache.formateurs[String(id)] = extras
        }
        save()
    }

    // MARK: - Session
    func getSessionExtras(id: Int64) -> SessionExtras? {
        queue.sync { cache.sessions[String(id)] }
    }

    func setSessionExtras(id: Int64, _ extras: SessionExtras?) {
        queue.sync {
            cache.sessions[String(id)] = extras
        }
        save()
    }
}

