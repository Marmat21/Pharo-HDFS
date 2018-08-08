Class {
	#name : #TokenHDFSAuth,
	#superclass : #HDFSAuthorizationStrategy,
	#instVars : [
		'token'
	],
	#category : #'HDFS-FileSystem'
}

{ #category : #'as yet unclassified' }
TokenHDFSAuth class >> withToken: aToken [
	^self new initializeWithToken: aToken.
]

{ #category : #'as yet unclassified' }
TokenHDFSAuth >> authorizationSuffix [
	^ 'delegation=' , token , '&'
]

{ #category : #'as yet unclassified' }
TokenHDFSAuth >> initializeWithToken: aToken [
	self initialize.
	token := aToken.
]
