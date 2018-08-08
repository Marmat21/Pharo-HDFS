Extension { #name : #FileSystem }

{ #category : #'*HDFS-FileSystem' }
FileSystem class >> hdfs [
	^ self store: HDFSStore new
]
