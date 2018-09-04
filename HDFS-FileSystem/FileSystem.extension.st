Extension { #name : #FileSystem }

{ #category : #'*HDFS-FileSystem' }
FileSystem class >> hdfs [
	^ self store: HDFSStore new
]

{ #category : #'*HDFS-FileSystem' }
FileSystem class >> hdfsAtHost: aHost user: user [
	^ self store: (HDFSStore host: aHost port: '9870' username: user).
]

{ #category : #'*HDFS-FileSystem' }
FileSystem class >> hdfsWithToken: aToken [
	^ self store: (HDFSStore authStrategy: (TokenHDFSAuth  withToken:  aToken))
]

{ #category : #'*HDFS-FileSystem' }
FileSystem class >> hdfsWithUser: anUser [
	^ self store: (HDFSStore authStrategy: (UsernameHDFSAuth withUsername: anUser))
]
