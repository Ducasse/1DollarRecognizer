Class {
	#name : #Dollar1StrokeWithAction,
	#superclass : #Dollar1Stroke,
	#instVars : [
		'action'
	],
	#category : #'OneDollarRecognizer-ShortcutApp'
}

{ #category : #accessing }
Dollar1StrokeWithAction >> action [
	^ action
]

{ #category : #accessing }
Dollar1StrokeWithAction >> action: anObject [
	action := anObject
]

{ #category : #'step 2' }
Dollar1StrokeWithAction >> executeAction [
	action value
]
