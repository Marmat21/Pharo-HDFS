Extension { #name : #FileSystem }

{ #category : #'*HDFS-FileSystem' }
FileSystem class >> hdfs [
	^ self store: HDFSStore new
]

{ #category : #'*HDFS-FileSystem' }
FileSystem class >> hdfsWithUser: anUser [
	^ self store: (HDFSStore authStrategy: (UsernameHDFSAuth withUsername: anUser))
]
