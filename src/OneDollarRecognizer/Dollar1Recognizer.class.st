Class {
	#name : #Dollar1Recognizer,
	#superclass : #Object,
	#instVars : [
		'templates'
	],
	#category : #'OneDollarRecognizer-Core'
}

{ #category : #template }
Dollar1Recognizer >> addTemplateNamed: name withPoints: points [
	| stroke |
	stroke := Dollar1Stroke new
		name: name;
		withPoints: points.
	templates add: stroke
]

{ #category : #'step 4' }
Dollar1Recognizer >> cosDistance: vec1 with: vec2 [
	"Not used.  Just the textbook definition of the cosine distance"
	| inner n1 n2 |
	inner := 0.0.
	n1 := 0.0.
	n2 := 0.0.
	vec1 with: vec2 do: [:v1 :v2 |
		inner := inner + (v1 x * v2 x) + (v1 y * v2 y).
		n1 := n1 + (v1 x * v1 x) + (v1 y * v1 y).
		n2 := n2 + (v2 x * v2 x) + (v2 y * v2 y)].
	n1 := n1 sqrt.
	n2 := n2 sqrt.
	^ (inner / (n1 * n2)) arcCos

]

{ #category : #'step 4' }
Dollar1Recognizer >> distance: stroke from: t atAngle: theta [
	| newPoints |
	newPoints := stroke rotate: stroke points by: theta.
	^ self pathDistance: newPoints from: t points.

]

{ #category : #'step 4' }
Dollar1Recognizer >> distanceAtBest: stroke from: t withThetaFrom: thetaA to: thetaB step: step [
	| x1 x2 phi f1 f2 tA tB |
	phi := 0.5 * (-1 + 5 sqrt).
	x1 := (phi * thetaA) + ((1 - phi) * thetaB).
	f1 := self distance: stroke from: t atAngle: x1.
	x2 := (1 - phi) * thetaA + (phi * thetaB).
	f2 := self distance: stroke from: t atAngle: x2.
	tA := thetaA.
	tB := thetaB.
	[(tB - tA) abs > step] whileTrue: [
		f1 < f2 ifTrue: [
			tB := x2.
			x2 := x1.
			f2 := f1.
			x1 := phi * tA + ((1 - phi) * tB).
			f1 := self distance: stroke from: t atAngle: x1]
		ifFalse: [
			tA := x1.
			x1 := x2.
			f1 := f2.
			x2 := (1 - phi) * tA + (phi * tB).
			f2 := self distance: stroke from: t atAngle: x2]
	].
	^ f1 min: f2.


]

{ #category : #initialization }
Dollar1Recognizer >> initialize [
	super initialize.
	templates := OrderedCollection new

]

{ #category : #'step 4' }
Dollar1Recognizer >> optimalCosDistance: stroke1 with: stroke2 [
	| a b angle vec1 vec2 ans1 ans2 ans3 |
	vec1 := stroke1 vector.
	vec2 := stroke2 vector.
	a := 0.
	b := 0.
	1 to: vec1 size do: [:i |
		a := a + ((vec1 at: i) x * (vec2 at: i) x) + ((vec1 at: i) y * (vec2 at: i) y).
		b := b + ((vec1 at: i) x * (vec2 at: i) y) - ((vec1 at: i) y * (vec2 at: i) x)].
	angle := (b/a) arcTan.
	ans1 := ((((a * angle cos) + (b * angle sin)) max: -1.0) min: 1.0) arcCos.
	ans2 := ((a max: -1.0) min: 1.0) arcCos.
	ans3 := ((((a * (angle + Float pi) cos) + (b * (angle + Float pi) sin)) max: -1.0) min: 1.0) arcCos.
	"vec3 := stroke1 rotate: vec2 by: angle."
"	ans3 < ans1 ifTrue: [
		self halt.
		((Float pi negated) to: (Float pi ) by: (Float pi / 90)) collect: [:p |
			((a * p cos) + (b * p sin)) arcCos.]]."
.
	^ ans1 min: ans3.
"	^ ((a * angle cos) + (b * angle sin)) arcCos"
	"vec3 := stroke1 rotate: vec2 by: angle.
	ans1 := self cosDistance: vec1 with: vec3.
	ans3 := self cosDistance: vec1 with: vec2.
	Transcript show: ('ans1: {1}, ans2: {2}, ans3 {3}' format: ({ans1. ans2. ans3} collect: [:e | e printShowingMaxDecimalPlaces: 3])); cr.
	Here, the result is always equal to ans1.  Interesting, eh?
"
]

{ #category : #'step 4' }
Dollar1Recognizer >> pathDistance: a from: b [
	^ (a with: b collect: [:ai :bi | ai dist: bi]) average
]

{ #category : #'step 4' }
Dollar1Recognizer >> recognize: points [
	^ self
		recognize: (Dollar1Stroke new withPoints: points)
		in: 250
]

{ #category : #'step 4' }
Dollar1Recognizer >> recognize: stroke in: size [
	| b d bestT theta |
	b := Float infinity.
	bestT := nil.
	theta := 45.
	
	templates do: [:t |
		d := self distanceAtBest: stroke from: t withThetaFrom: theta negated to: theta step: 2.
		d < b ifTrue: [
			b := d.
			bestT := t]].
	
	b isInfinite ifTrue: [ b := 0.0 ].
	
	^ Dollar1Result new
		stroke: bestT;
		likeness: 1 - ( 2 * b / (size * 2 sqrt))
]

{ #category : #template }
Dollar1Recognizer >> templates [
	^ templates

]

{ #category : #template }
Dollar1Recognizer >> templates: collectionOfDollar1Strokes [
	templates := collectionOfDollar1Strokes

]
