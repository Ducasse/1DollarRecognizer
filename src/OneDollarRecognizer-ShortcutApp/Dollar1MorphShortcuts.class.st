Class {
	#name : #Dollar1MorphShortcuts,
	#superclass : #BorderedMorph,
	#instVars : [
		'recognizer',
		'points',
		'button',
		'protractor',
		'lastResult',
		'templateHolder',
		'haveToExecuteAction',
		'buttonExecuteActions',
		'label'
	],
	#category : #'OneDollarRecognizer-ShortcutApp'
}

{ #category : #all }
Dollar1MorphShortcuts class >> example [
	self new openInWindowLabeled: 'ShortcutApp'

]

{ #category : #all }
Dollar1MorphShortcuts class >> recognizer [
	^Dollar1ProtractorRecognizer
]

{ #category : #all }
Dollar1MorphShortcuts class >> templateHolder [
	^ Dollar1RegisteredShortcuts
]

{ #category : #'creating morphs' }
Dollar1MorphShortcuts >> createButtonAddTemplate [
	^ SimpleButtonMorph new
		label: 'Save template';
		color: (Color gray: 0.8);
		target: self;
		actWhen: #buttonUp;
		actionSelector: #showPopUpAddTemplate;
		setBalloonText: 'Register the current points into a new template'

]

{ #category : #'creating morphs' }
Dollar1MorphShortcuts >> createButtonExecuteActions [
	^ SimpleButtonMorph new
		label: 'Actions activated: ', haveToExecuteAction asString;
		color: (Color gray: 0.8);
		target: self;
		actWhen: #buttonUp;
		actionSelector: #switchExecuteAction;
		setBalloonText: 'Does the recognizer have to trigger associated actions ?'

]

{ #category : #initialization }
Dollar1MorphShortcuts >> defaultExtend [
	^400@400
]

{ #category : #drawing }
Dollar1MorphShortcuts >> drawOn: aCanvas [
	| curP lastP |
	super drawOn: aCanvas.
	2 to: points size do: [ :i |
		lastP := points at: i - 1.
		curP := points at: i.
		aCanvas line: lastP to: curP width: 6 color: Color black ].

]

{ #category : #events }
Dollar1MorphShortcuts >> handlesMouseDown: evt [
	^ true
]

{ #category : #events }
Dollar1MorphShortcuts >> handlesMouseMove: anEvent [ 
	^ true
]

{ #category : #initialization }
Dollar1MorphShortcuts >> initialize [

	| buttonAddTemplate |
	super initialize.
	
	haveToExecuteAction := true.
	recognizer := self class recognizer new.
	templateHolder := self class templateHolder.
	recognizer templates: templateHolder templates .
	points := #().
	self color: (Color gray: 0.9).
	
	self extent: self defaultExtend.
	
	self addMorph: ((label := StringMorph contents: '<result>' font: (TextStyle default fontOfSize: 20) emphasis: 0) extent: 300@25).
	label position: self topLeft.

	buttonAddTemplate := self createButtonAddTemplate .
	self addMorph: buttonAddTemplate.
	buttonAddTemplate bottomRight: self bottomRight.
	
	buttonExecuteActions := self createButtonExecuteActions.
	buttonExecuteActions bottomLeft: self bottomLeft.
	self addMorph: buttonExecuteActions .

]

{ #category : #accessing }
Dollar1MorphShortcuts >> lastResult [
	^ lastResult
]

{ #category : #events }
Dollar1MorphShortcuts >> mouseDown: evt [
	points := OrderedCollection new.
]

{ #category : #events }
Dollar1MorphShortcuts >> mouseMove: evt [
	evt buttons = 4 ifTrue: [
		points add: evt startPoint.
		points addAll: evt trail.
	].
	self changed.

]

{ #category : #events }
Dollar1MorphShortcuts >> mouseUp: evt [
	points add: evt position.
	self recognize.
]

{ #category : #private }
Dollar1MorphShortcuts >> print3Digits: aNumber [
		^ (aNumber roundTo: 0.001) printString.

]

{ #category : #events }
Dollar1MorphShortcuts >> recognize [
	points size < 2
		ifTrue: [ ^ self ].
		
	lastResult := recognizer recognize: points.
	
	haveToExecuteAction
		ifTrue: [ lastResult stroke executeAction ].
		
	label contents: lastResult stroke name , ', ' , (self print3Digits: lastResult likeness)
]

{ #category : #accessing }
Dollar1MorphShortcuts >> recognizer: aRecognizer [

	recognizer := aRecognizer
]

{ #category : #'registering new template' }
Dollar1MorphShortcuts >> showPopUpAddTemplate [
	| name action |
	name := (UITheme builder openModal: 
        (TextEntryDialogWindow new
                title: 'Register a new template';
                textFont: StandardFonts defaultFont;
                text: 'Enter the name')) entryText.	
	
	"Cancel if the name is not valid"
	(name = nil or: [ name = '' ])
		ifTrue: [ ^ self ].
		
	action := (UITheme builder openModal: 
        (TextEntryDialogWindow new
                title: 'Register a new template';
                textFont: StandardFonts defaultFont;
                text: 'Enter the block to execute when recognized')) entryText.

	"Register the new template"
	templateHolder addTemplate: points as: name action: action.
	recognizer templates: templateHolder templates
]

{ #category : #private }
Dollar1MorphShortcuts >> switchExecuteAction [
	haveToExecuteAction := haveToExecuteAction not.
	buttonExecuteActions label: 'Actions activated: ', haveToExecuteAction asString
]
