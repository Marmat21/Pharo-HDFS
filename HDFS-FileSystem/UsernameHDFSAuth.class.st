Class {
	#name : #UsernameHDFSAuth,
	#superclass : #HDFSAuthorizationStrategy,
	#instVars : [
		'username'
	],
	#category : #'HDFS-FileSystem'
}

{ #category : #'as yet unclassified' }
UsernameHDFSAuth class >> withUsername: anUsername [
	^self new initializeWithUsername: anUsername.
]

{ #category : #'as yet unclassified' }
UsernameHDFSAuth >> authorizationSuffix [
	^ 'user.name=' , username , '&'
]

{ #category : #'as yet unclassified' }
UsernameHDFSAuth >> initializeWithUsername: aUsername [
	self initialize.
	username := aUsername.
]
