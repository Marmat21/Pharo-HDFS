Class {
	#name : #HDFSReadStream,
	#superclass : #Object,
	#instVars : [
		'fileReference',
		'position',
		'fileSize'
	],
	#category : #'HDFS-FileSystem'
}

{ #category : #'instance creation' }
HDFSReadStream class >> on: aFileReference [ 
	
	^ self new
		fileReference: aFileReference;
		yourself
]

{ #category : #testing }
HDFSReadStream >> atEnd [
	
	^ position >= fileSize
]

{ #category : #closing }
HDFSReadStream >> close [
	
	"Do nothing, there is no closing file here"
]

{ #category : #accessing }
HDFSReadStream >> fileReference: aFileReference [ 
	fileReference := aFileReference.
	fileSize := fileReference size.
]

{ #category : #testing }
HDFSReadStream >> initialize [

	super initialize.
	position := 0
]

{ #category : #testing }
HDFSReadStream >> isBinary [
	
	^ true
]

{ #category : #reqding }
HDFSReadStream >> readInto: aCollection startingAt: anInteger count: anInteger3 [
	| readBytes |
	readBytes := (fileReference fileSystem store
		request: fileReference path
		operation: 'OPEN&offset=' , (anInteger - 1) asString , '&length=' , anInteger3 asString)
		contents.
	aCollection
		replaceFrom: anInteger
		to: anInteger + readBytes size - 1
		with: readBytes
		startingAt: 1.
	position := position + readBytes size.
	^ readBytes size
]
