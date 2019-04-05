Class {
	#name : #Dollar1TemplateHolder,
	#superclass : #Object,
	#category : #'OneDollarRecognizer-Core'
}

{ #category : #'instance creation' }
Dollar1TemplateHolder class >> addTemplate: points as: templateName [
	"self addTemplate: { 0@0. 1@0. 0@1. 1@1} 
		as: 'zLikeZorro'"
	| methodStream |
	methodStream := ReadWriteStream on: String new.
	methodStream << templateName;
		nextPut: Character cr;
	 	<< '	<Dollar1Template>';
		nextPut: Character cr;
		<< '	^ Dollar1Stroke new
		name: ';
		nextPut: $';
		<< templateName;
		nextPut: $';
		<< ';
		withPoints: {'.
	points do: [ :each | methodStream nextPutAll: (each  rounded) asString;
		nextPutAll: '. '
		; nextPut: Character cr ].
	methodStream << '}'.	
	self compile: methodStream contents
]

{ #category : #'instance creation' }
Dollar1TemplateHolder class >> addTemplate: points as: templateName action: action [
	"self addTemplate: { 0@0. 1@0. 0@1. 1@1} 
		as: 'zLikeZorro' 
		action: [ Smalltalk tools openWorkspace ]"
	| methodStream |
	methodStream := ReadWriteStream on: String new.
	methodStream << templateName;
		nextPut: Character cr;
	 	<< '	<Dollar1Template>';
		nextPut: Character cr;
		<< '	^ Dollar1Stroke new
		name: ';
		nextPut: $';
		<< templateName;
		nextPut: $';
		<< ';
		withPoints: {'.
	points do: [ :each | methodStream nextPutAll: (each  rounded) asString;
		nextPutAll: '. '
		; nextPut: Character cr ].
	methodStream << '};
		action: ';
		<< action asString.	
	self compile: methodStream contents
]

{ #category : #templates }
Dollar1TemplateHolder class >> templates [
	| pragmas methods |
	pragmas := Pragma allNamed: #Dollar1Template in: self.
	methods := pragmas collect: [ :each | each method ].
	^ methods collect: [ :method | method valueWithReceiver: self arguments: #() ]
]
