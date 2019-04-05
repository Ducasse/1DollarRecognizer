Class {
	#name : #Dollar1Stroke,
	#superclass : #Object,
	#instVars : [
		'name',
		'points',
		'vector',
		'curvature'
	],
	#category : #'OneDollarRecognizer-Core'
}

{ #category : #accessing }
Dollar1Stroke >> curvature [
	^ curvature

]

{ #category : #grail }
Dollar1Stroke >> drectionOf: newVector previous: prevDirection [
	| base diff histerisis theta threshold data |
	data := #((0.0 #right) (1.5707963267948966 #up) (3.141592653589793 #left) (4.71238898038469 #down)).
	histerisis := 12 degreesToRadians.
	threshold := 45.1 degreesToRadians.
	theta := newVector theta.
	prevDirection ifNotNil: [
		base := (data detect: [:pair | pair second == prevDirection]) first.
		diff := theta - base.
		diff > Float pi ifTrue: [diff := diff - (Float pi * 2)].
		diff abs < (threshold + histerisis) ifTrue: [
			^ prevDirection]].
	data do: [:pair |
		diff := theta - pair first.
		diff > Float pi ifTrue: [diff := diff - (Float pi * 2)].
		diff abs < threshold ifTrue: [
			^ pair second]].

]

{ #category : #grail }
Dollar1Stroke >> grailCurvature: ps [
	| directions newDirection prevDirection vec cur smoothed |
	directions := OrderedCollection new.
	smoothed := ps first.
	2 to: ps size do: [:i |
		cur := (ps at: i) * 0.25 + (smoothed * 0.75).
		vec := cur - smoothed.
		smoothed := cur.
		prevDirection := directions size = 0 ifTrue: [nil] ifFalse: [directions last].
		newDirection := self drectionOf: vec previous: prevDirection.
		prevDirection ~~ newDirection ifTrue: [
			directions add: newDirection]].
	^ directions.

]

{ #category : #'step 2' }
Dollar1Stroke >> indicativeAngle: ps [
	^ (ps first - ps average) theta.

]

{ #category : #accessing }
Dollar1Stroke >> name [
	^ name

]

{ #category : #accessing }
Dollar1Stroke >> name: aString [
	name := aString

]

{ #category : #'step 1' }
Dollar1Stroke >> pathLength: ps [
	| d lastP currentP |
	d := 0.
	lastP := ps first.
	2 to: ps size do: [:i |
		currentP := ps at: i.
		d := d + (lastP dist: currentP).
		lastP := currentP.
	].
	^ d.

]

{ #category : #accessing }
Dollar1Stroke >> points [
	^ points

]

{ #category : #initialization }
Dollar1Stroke >> preProcess [
	| radians |
	vector := (self resample: points asOrderedCollection with: 16) asArray.
	points := (self resample: points asOrderedCollection with: 64) asArray.

	points := self translate: points to: 0@0.
	radians := self indicativeAngle: points.
	points := self rotate: points by: radians.
	"This is a bit tricky, but calculating the GRAIL-like curvature needs to be done before scaling."
	curvature := self grailCurvature: points.
	points := self scale: points to: 250.

	vector := self translate: vector to: 0@0.
	radians := self indicativeAngle: vector.
	vector := (self vectorize: vector angle: radians oSensitive: true) asArray.


]

{ #category : #printing }
Dollar1Stroke >> printOn: aStream [
	aStream nextPutAll: self class name.
	aStream nextPutAll: '('.
	aStream nextPutAll: (name ifNil: ['*']).
	aStream nextPutAll: ')'.

]

{ #category : #'step 1' }
Dollar1Stroke >> resample: ps with: n [
	| d newPoints dd q currentP ii lastP i |
	ii := (self pathLength: ps) / (n - 1) asFloat.
	dd := 0.
	newPoints := OrderedCollection with: ps first.
	i := 2.
	[i <= ps size] whileTrue: [
		lastP := ps at: i - 1.
		currentP := ps at: i.
		d := lastP dist: currentP.
		dd + d >= ii ifTrue: [
			q := lastP + (((ii - dd) / d) * (currentP - lastP)).
			newPoints add: q.
			ps add: q beforeIndex: i.
			dd := 0]
		ifFalse: [
			dd := dd + d
		].
		i := i + 1].
	newPoints size = (n - 1) ifTrue: [newPoints add: ps last].
	^ newPoints.

]

{ #category : #'step 2' }
Dollar1Stroke >> rotate: ps by: rad [
	^ ps collect: [:p |
		| r theta |
		r := p r.
		theta := rad asFloat - p theta.
		((r * theta cos)) @  (0 - (r * theta sin))].

]

{ #category : #'step 3' }
Dollar1Stroke >> scale: ps to: size [
	| bbExt |
	bbExt := (Rectangle encompassing: ps) extent.
	^ ps collect: [:p | p * size / bbExt].

]

{ #category : #printing }
Dollar1Stroke >> show: ps scale: scale [
	| c f pp |
	f := Form extent: 250@250 depth: 32.
	f fillColor: Color white.
	c := f getCanvas.
	ps do: [:p |
		pp := (p * scale) + (f extent // 2).
		c fillOval: (pp - (2@2) extent: 4@4) color: Color black borderWidth: 0 borderColor: Color transparent].
	f displayAt: 0@500


]

{ #category : #'step 3' }
Dollar1Stroke >> translate: ps to: newC [
	| c |
	c := ps average - newC.
	^ ps collect: [:p | p - c].

]

{ #category : #accessing }
Dollar1Stroke >> vector [
	^ vector

]

{ #category : #printing }
Dollar1Stroke >> vectorize: ps angle: indicativeAngle oSensitive: oSensitive [
	| baseOrientation delta  sum magnitude newPoints vec |
	vec := OrderedCollection new.
	oSensitive ifTrue: [
		baseOrientation := (Float pi / 4.0) * (indicativeAngle + (Float pi / 8.0) / (Float pi / 4.0)) floor.
		delta := indicativeAngle -  baseOrientation]
	ifFalse: [
		delta := indicativeAngle].
	sum := 0.
	newPoints := self rotate: ps by: delta.
	newPoints do: [:p |
		vec add: p.
		sum := sum + (p x * p x) + (p y * p y)].
	magnitude := sum sqrt.
	^ vec collect: [:e | e / magnitude].

]

{ #category : #initialization }
Dollar1Stroke >> withPoints: ps [
	points := ps.
	self preProcess

]
