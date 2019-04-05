Class {
	#name : #Dollar1Result,
	#superclass : #Object,
	#instVars : [
		'stroke',
		'likeness'
	],
	#category : #'OneDollarRecognizer-Core'
}

{ #category : #accessing }
Dollar1Result >> initialize [
	likeness := 0.0.
	stroke := Dollar1Stroke new.
]

{ #category : #accessing }
Dollar1Result >> likeness [
	^ likeness
]

{ #category : #accessing }
Dollar1Result >> likeness: anObject [
	likeness := anObject
]

{ #category : #accessing }
Dollar1Result >> stroke [
	^ stroke
]

{ #category : #accessing }
Dollar1Result >> stroke: anObject [
	stroke := anObject
]
