import SwiftUI

struct ExerciseSet: Identifiable, Equatable {
    var id: UUID
    var isCompleted: Bool = false
    var numberOfUnits: Int
}

enum ExerciseUnitType {
    case repetitions
    case seconds
}

struct Exercise: Identifiable {
    var id: UUID
    var name: String
    var unitType: ExerciseUnitType = ExerciseUnitType.repetitions
    var sets: [ExerciseSet]?
}

struct SetView: View {
    var set: ExerciseSet
    
    var body: some View {
        Text("Set \(set.id)")
    }
}

struct ExerciseView: View {
    var exercise: Exercise
    
    var body: some View {
        DisclosureGroup {
            List(exercise.sets ?? []) { set in
                SetView(set: set)
            }
        } label: {
            Label(exercise.name, systemImage: "dumbbell.fill")
        }
    }
}
