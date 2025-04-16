import Foundation

class GoalTypes {
    static let shared = GoalTypes()
    
    private init() {}
    
    var sleepBad: [String: String] = [
        "Take a 5-minute sunlight break": "Take a 5-minute sunlight break in the morning to help regulate your circadian rhythm",
        "Prioritize hydration": "Drink a full glass of water to support cognitive function",
        "Do light movement": "Do a short walk or short stretching session to wake up your body",
        "Avoid excessive caffeine after noon": "Avoid excessive caffeine after noon to improve sleep quality"
    ]
    
    var energyBad: [String: String] = [
        "Try 5 minutes of deep breathing": "Try 5 minutes of deep breathing to regulate your circadian rhythm",
        "Stand up and do 10 bodyweight squats or a short walk": "Stand up and do 10 bodyweight squats or a short walk to increase circulation",
        "Have a protein + healthy fat snack": "Have a protein + healthy fat snack like nuts, yogurt or eggs to stabelize energy levels",
        "Listen to an energizing song": "Listen to an energizing song to boost your mood and energy levels"
        ]
    
    var stressBad: [String: String] = [
        "Take a 60 second pause": "Take a minute to do a grounding exercise like the 5-4-3-2-1 technique",
        "Write down 1 thing you can control": "Write down 1 thing you can control and take charge of it",
        "Reach out to a friend or colleague": "Reach out to someone you know and trust for a quick chat or check-in",
        "Do a quick physical reset": "Stretch, shake it out, or step outside to relax"
        ]
    
    var tensionHigh: [String: String] = [
        "Try 5 minutes of mobility work": "Do some neck rolls, shoulder shrugs, or cat-cow stretches",
        "Do a 2-minute progressive muscle relaxation exercise": "tense and release muscles from head to toe over two minutes",
        "Use a foam roller or massage ball": "Use a foam roller or massage ball for a quick self-release",
        "Take a short movement break": "Walk around, stretch, or stand up for a minute"
        ]
    
    var unfocused: [String: String] = [
        "Do a 3-minute eye relaxation exercise": "Look 20 feet away for 20 sec, blink slowly, then refocus",
        "Try the 5-5-5 cognitive reset": "Inhale for 5 sec, hold 5 sec, exhale for 5 sec",
        "Write down the ONE most important thing to focus on": "Write down the one most important thing to focus on and commit to it",
        "Use the 25-minute Pomodoro technique": "Work for 25 minutes, take a short break, and work for 25 minutes"
        ]
    
    var breathingBad: [String: String] = [
        "Do a quick breath check-in": "Breathe in through the nose for 4 seconds, out for 6 seconds",
        "Try diaphragmatic breathing": "Place your hand on your belly, breathe deep into your stomach",
        "Slowly exhale twice as long as you inhale": "Slowly exhale twice as long as you inhale for to trigger relaxation"
        ]
    
    var socialBad: [String: String] = [
        "Send a quick message to someone you care about": "Send a text, voice note, or email",
        "Engage in small talk with a colleague or friend": "Speak to someone. Even small conversations can be refreshing",
        "Give a genuine compliment": "Compliment someone. Kind words go a long way for you and others",
        "join a short social or team break if available": "Join a coffee chat, group chat check-in, etc."
    ]
    
    var mindfulnessBad: [String: String] = [
        "Step outside for 2 minutes": "Step outside and take a deep breath",
        "Close your eyes and do 10 slow, deep breaths": "Close your eyes and do 10 slow, deep breaths before returning to work",
        "Stretch or do a quick body scan": "Stretch or do a quick body scan to relax and rejuvenate",
        "Do a 1-minute gratitude reflection": "Name 3 things you are grateful for and write them down"
        ]
    
    func getRandom(
        type: Int
    ) -> String {
        switch type {
        case 0:
            return sleepBad.randomElement()?.key ?? ""
        case 1:
            return energyBad.randomElement()?.key ?? ""
        case 2:
            return stressBad.randomElement()?.key ?? ""
        case 3:
            return tensionHigh.randomElement()?.key ?? ""
        case 4:
            return unfocused.randomElement()?.key ?? ""
        case 5:
            return breathingBad.randomElement()?.key ?? ""
        case 6:
            return socialBad.randomElement()?.key ?? ""
        case 7:
            return mindfulnessBad.randomElement()?.key ?? ""
        default:
            return ""
        }
    }
    
    func getDefinition(
        name: String
    ) -> String {
        let goals: [Dictionary<String, String>] = [sleepBad, energyBad, stressBad, tensionHigh, unfocused, breathingBad, socialBad, mindfulnessBad]
        
        for goal in goals {
            if goal[name] != nil {
                return goal[name]!
            }
        }
        
        return ""
    }
    
}
