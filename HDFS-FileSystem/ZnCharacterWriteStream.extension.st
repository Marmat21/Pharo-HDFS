Extension { #name : #ZnCharacterWriteStream }

{ #category : #'*HDFS-FileSystem' }
ZnCharacterWriteStream >> appendAll: aCollection [
	self setToEnd.
	self nextPutAll: aCollection.
	self flush.
]
