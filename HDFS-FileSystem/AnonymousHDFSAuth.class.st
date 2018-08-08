Class {
	#name : #AnonymousHDFSAuth,
	#superclass : #HDFSAuthorizationStrategy,
	#category : #'HDFS-FileSystem'
}

{ #category : #'as yet unclassified' }
AnonymousHDFSAuth >> authorizationSuffix [
	^''.
]
