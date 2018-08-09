Extension { #name : #ZnBufferedWriteStream }

{ #category : #'*HDFS-FileSystem' }
ZnBufferedWriteStream >> appendAll: aCollection [
	self setToEnd.
	self nextPutAll: aCollection.
]
