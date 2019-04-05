Class {
	#name : #Dollar1ProtractorRecognizer,
	#superclass : #Dollar1Recognizer,
	#category : #'OneDollarRecognizer-Core'
}

{ #category : #'step 4' }
Dollar1ProtractorRecognizer >> recognize: points [
	| maxScore match distance score |
	maxScore := 0.

	templates do: [:registeredStroke |
		distance := self optimalCosDistance: registeredStroke with: (Dollar1Stroke new withPoints: points).
		score := 1 / distance.
		score > maxScore ifTrue: [
			maxScore := score.
			match := registeredStroke]].
	^ Dollar1Result new stroke: match; likeness: maxScore.

]
