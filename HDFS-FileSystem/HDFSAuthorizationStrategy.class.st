Class {
	#name : #HDFSAuthorizationStrategy,
	#superclass : #Object,
	#category : #'HDFS-FileSystem'
}

{ #category : #'as yet unclassified' }
HDFSAuthorizationStrategy >> authorizationSuffix [
	self subclassResponsibility.
]
