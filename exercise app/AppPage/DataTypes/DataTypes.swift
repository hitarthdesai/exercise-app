import Foundation

struct Exercise: Identifiable {
    var id: UUID
    var name: String
}

struct Workout: Identifiable {
    var id: UUID
    var name: String
    var exercises: [Exercise]
}
