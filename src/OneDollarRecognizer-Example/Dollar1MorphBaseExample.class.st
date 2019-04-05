"
Dollar1Morph new openInWorld 
"
Class {
	#name : #Dollar1MorphBaseExample,
	#superclass : #BorderedMorph,
	#instVars : [
		'recognizer',
		'points',
		'label',
		'button',
		'protractor',
		'field',
		'lastResult'
	],
	#category : #'OneDollarRecognizer-Example'
}

{ #category : #all }
Dollar1MorphBaseExample class >> example [
	self new openInWindowLabeled: '$1 Recognizer'

]

{ #category : #all }
Dollar1MorphBaseExample class >> samplePicture [
	| url |
	url := 'http://depts.washington.edu/aimgroup/proj/dollar/unistrokes.gif'.
	^( [GIFReadWriter formFromFileNamed: (url copyAfterLast: $/)]
		on: FileDoesNotExistException do: [:ex |
			| data |
			data := ZnClient new
						beOneShot;
						url: url;
						get.
			FileStream newFileNamed: (url copyAfterLast: $/)
				do: [:file | file binary; nextPutAll: data].
			GIFReadWriter formFromStream: (ReadStream on: data)]) preMultiplyAlpha
]

{ #category : #events }
Dollar1MorphBaseExample >> accept: morph [
	points size > 1
		ifTrue: [ 
			recognizer addTemplate: points as: morph contents asString.
			^ true ].
	^ false
]

{ #category : #initialization }
Dollar1MorphBaseExample >> buildInputField [
	^ PluggableTextMorph new
		on: self
		text: nil
		accept: #accept:
		readSelection: nil
		menu: nil;
		acceptOnCR: true;
		color: Color white;
		hideVScrollBarIndefinitely: true;
		yourself

]

{ #category : #events }
Dollar1MorphBaseExample >> button [
	^ SimpleButtonMorph new
		color: (Color lightBlue);
		target: self;
		actWhen: #buttonUp;
		actionSelector: #toggle;
		setBalloonText: 'Toggle the state'

]

{ #category : #drawing }
Dollar1MorphBaseExample >> drawOn: aCanvas [
	| curP lastP |
	super drawOn: aCanvas.
	2 to: points size do: [ :i |
		lastP := points at: i - 1.
		curP := points at: i.
		aCanvas line: lastP to: curP width: 2 color: Color black ].

]

{ #category : #events }
Dollar1MorphBaseExample >> handlesMouseDown: evt [
	^ true
]

{ #category : #events }
Dollar1MorphBaseExample >> handlesMouseMove: anEvent [ 
	^ true
]

{ #category : #private }
Dollar1MorphBaseExample >> imageMorph: aForm [
	^ ImageMorph new image: aForm

]

{ #category : #initialization }
Dollar1MorphBaseExample >> initialize [
	| samplePicture sketch |
	super initialize.
	recognizer := Dollar1Recognizer new.
	recognizer templates: Dollar1RecognizerExampleTemplates templates .
	points := #().
	self color: (Color gray: 0.9).
	samplePicture := self class samplePicture.
	sketch := self imageMorph: samplePicture.
	self extent: samplePicture extent * (2@1).
	self addMorph: sketch.
	sketch topLeft: 0@0.
	self addMorph: ((label := StringMorph contents: '<result>' font: (TextStyle default fontOfSize: 20) emphasis: 0) extent: 300@25).
	label position: sketch topRight.

	self addMorph: (field := self buildInputField).
	field extent: (300@25).
	field bottomRight: self bottomRight.

	self protractor: true.
	self addMorph: (button := self button).
	self toggle.

]

{ #category : #accessing }
Dollar1MorphBaseExample >> lastResult [
	^ lastResult
]

{ #category : #events }
Dollar1MorphBaseExample >> mouseDown: evt [
	points := OrderedCollection new.

]

{ #category : #events }
Dollar1MorphBaseExample >> mouseMove: evt [
	evt buttons = 4 ifTrue: [
		points add: evt startPoint.
		points addAll: evt trail.
	].
	self changed.

]

{ #category : #events }
Dollar1MorphBaseExample >> mouseUp: evt [
	super mouseUp: evt.
	points add: evt position.
	self recognize.
]

{ #category : #private }
Dollar1MorphBaseExample >> print3Digits: aNumber [
	(aNumber respondsTo: #printShowingMaxDecimalPlaces:) ifTrue: [
		^ aNumber printShowingMaxDecimalPlaces: 3]
	ifFalse: [
		^ (aNumber truncateTo: 0.001) printString].

]

{ #category : #accessing }
Dollar1MorphBaseExample >> protractor [

	^ protractor
]

{ #category : #accessing }
Dollar1MorphBaseExample >> protractor: aBoolean [

	protractor := aBoolean.
	aBoolean 
		ifTrue: [ self setProtractor ]
		ifFalse: [ self setRecognizer ]
]

{ #category : #events }
Dollar1MorphBaseExample >> recognize [
	points size < 2 ifTrue: [^ self].
	lastResult := recognizer recognize: points.
	label contents: lastResult stroke name, ', ', (self print3Digits: lastResult likeness)

]

{ #category : #accessing }
Dollar1MorphBaseExample >> recognizer: aRecognizer [

	recognizer := aRecognizer
]

{ #category : #accessing }
Dollar1MorphBaseExample >> setProtractor [
	| newRecognizer |
	newRecognizer := Dollar1ProtractorRecognizer new templates: recognizer templates.
	recognizer := newRecognizer
]

{ #category : #accessing }
Dollar1MorphBaseExample >> setRecognizer [
	| newRecognizer |
	newRecognizer := Dollar1Recognizer new templates: recognizer templates.
	recognizer := newRecognizer
]

{ #category : #events }
Dollar1MorphBaseExample >> toggle [

	button label: (self protractor ifTrue: ['$1'] ifFalse: ['Protractor']) font: (TextStyle default fontOfSize: 20).
	button topRight: self topRight.
	self protractor: self protractor not.

]
