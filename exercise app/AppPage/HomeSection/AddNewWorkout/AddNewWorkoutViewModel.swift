import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class AddNewWorkoutViewModel: ObservableObject {
    @Published var isWorkoutNameSet: Bool = false
    @Published var workoutName: String = "" {
        didSet {
            self.isWorkoutNameSet = self.workoutName.count != 0
        }
    }
    
    enum TargetBodyPart: String {
        case shoulders = "shoulders"
        case abs = "abs"
        case back = "back"
        case arms = "arms"
        case chest = "chest"
        case legs = "legs"
        case cardio = "cardio"
    }
    @Published var targetBodyPart: TargetBodyPart = .abs {
        didSet {
            Task {
                print("Changed Target Body Part To \(targetBodyPart.rawValue)")
                let newTargetBodyPart = targetBodyPart.rawValue
                self.isExercisesForTargetBodyPartFetched = false
                await FetchExercisesForTargetBodyPart(targetBodyPart: newTargetBodyPart)
            }
        }
    }
    
    @Published var isExercisesForTargetBodyPartFetched: Bool = false
    @Published var exercisesForTargetBodyPart: [Exercise] = [Exercise(id: UUID(), name: "")]
    private func FetchExercisesForTargetBodyPart(targetBodyPart: String) async {
        self.exercisesForTargetBodyPart.removeAll()
        let db = Firestore.firestore()
        let exercisesCollection = db.collection("exercises")
        let targetBodyPartQuery = exercisesCollection.whereField("bodyPart", isEqualTo: targetBodyPart)
        
        do {
            let targetBodyPartExercises = try await targetBodyPartQuery.getDocuments().documents
            for exercise in targetBodyPartExercises {
                let exerciseData = exercise.data()
                let exerciseName = exerciseData["name"] as! String
                let exerciseStruct = Exercise(id: UUID(), name: exerciseName)
                self.exercisesForTargetBodyPart.append(exerciseStruct)
            }
            self.isExercisesForTargetBodyPartFetched = true
        } catch let exerciseQueryError as NSError {
            switch(exerciseQueryError) {
            default:
                print("Bruh")
            }
        }
    }

    @Published var addedExercises: [Exercise] = []
}
