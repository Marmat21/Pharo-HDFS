Class {
	#name : #HDFSWriteStream,
	#superclass : #Object,
	#instVars : [
		'fileReference',
		'position'
	],
	#category : #'HDFS-FileSystem'
}

{ #category : #'instance creation' }
HDFSWriteStream class >> fileReference: fileReference. [
]

{ #category : #'instance creation' }
HDFSWriteStream class >> on: fileReference [
	^ self new fileReference: fileReference.
]

{ #category : #'as yet unclassified' }
HDFSWriteStream >> appendAll: data [
	| store result finalRes client url |
	store := fileReference fileSystem store.
	result := store
		post: fileReference path
		operation: 'APPEND&noredirect=false'
		follow: false.
	client := ZnClient new.
	url := result headers at: 'Location'.
	finalRes := client
		url: url;
		contents: data;
		post;
		response.
	^ client
		url: url;
		contents: #();
		post;
		response
]

{ #category : #'as yet unclassified' }
HDFSWriteStream >> close [
	"if file does not exist, create it, otherwise do nothing"
	fileReference exists ifFalse: [ fileReference fileSystem store createFile: fileReference path ]
]

{ #category : #accessing }
HDFSWriteStream >> fileReference: aFileReference [
	fileReference := aFileReference.
]

{ #category : #'as yet unclassified' }
HDFSWriteStream >> flush [
	"always flushes"

]

{ #category : #accessing }
HDFSWriteStream >> initialize [
	super initialize.
	position := 0.
]

{ #category : #'as yet unclassified' }
HDFSWriteStream >> isBinary [
	^ true.
]

{ #category : #'as yet unclassified' }
HDFSWriteStream >> nextPutAll: aCollection [ 
	^self appendAll: aCollection
]

{ #category : #'as yet unclassified' }
HDFSWriteStream >> setToEnd [
	"always at end"
]
