Class {
	#name : #HDFSStore,
	#superclass : #FileSystemStore,
	#instVars : [
		'host',
		'port',
		'authStrategy'
	],
	#category : #'HDFS-FileSystem'
}

{ #category : #'instance creation' }
HDFSStore class >> authStrategy: aStrategy [
	^self new initializeWithAuthStrategy: aStrategy
]

{ #category : #'instance creation' }
HDFSStore class >> host: anHost port: aPort [ 
	^self host: anHost port: aPort authStrategy:  AnonymousHDFSAuth.
]

{ #category : #'instance creation' }
HDFSStore class >> host: anHost port: aPort authStrategy: aStrategy [
	^self new initializeWithHost: anHost port: aPort authStrategy: aStrategy
]

{ #category : #public }
HDFSStore >> basenameFromEntry: aJsonEntry [
	
	^ aJsonEntry at: 'pathSuffix'
]

{ #category : #abstract }
HDFSStore >> basicCreationTimeOf: aJsonFile [ 
	^ DateAndTime fromUnixTime:  (aJsonFile at: 'modificationTime') / 1000
]

{ #category : #abstract }
HDFSStore >> basicEntry: directoryEntry path: aPath nodesDo: aBlock [
	| response json |
	response := self request: aPath operation: 'LISTSTATUS'.
	json := (STONJSON fromString: response contents) at: 'FileStatuses'.
	(json at: 'FileStatus') do: [ :each | aBlock value: each ]
]

{ #category : #abstract }
HDFSStore >> basicIsDirectory: aNode [
	
	^ (aNode at: 'type') = 'DIRECTORY'.
]

{ #category : #abstract }
HDFSStore >> basicIsFile: aNode [
	
	^ (aNode at: 'type') = 'FILE'.
]

{ #category : #accessing }
HDFSStore >> basicOpen: path writable: aBoolean [ 
	
	^ self
		nodeAt: path
		ifPresent: [ :aMemoryFileSystemEntry | aMemoryFileSystemEntry ]
		ifAbsent: [ 
			aBoolean
				ifFalse: [ self signalFileDoesNotExist: path ]
				ifTrue: [ self createFile: path ] ]
]

{ #category : #abstract }
HDFSStore >> basicSizeOf: aNode [
	^ aNode at: 'length'.
]

{ #category : #abstract }
HDFSStore >> createDirectory: aPath [
	self put: aPath operation: 'MKDIRS' data: (ZnStringEntity text: '').
]

{ #category : #accessing }
HDFSStore >> defaultWorkingDirectory [
	^ Path
		from:
			((STONJSON
				fromString: (self request: Path new operation: 'GETHOMEDIRECTORY') contents)
				at: 'Path')
]

{ #category : #printing }
HDFSStore >> delete: aPath [ 
	^ ZnEasy
		delete: ('http://' , host , ':' , port , '/webhdfs/v1' , aPath pathString , '?' , authStrategy authorizationSuffix , 'op=DELETE' ).
]

{ #category : #accessing }
HDFSStore >> delimiter [
	
	^ $/
]

{ #category : #printing }
HDFSStore >> forReferencePrintOn: aStream [
	
	aStream nextPutAll: 'hdfs://'
]

{ #category : #accessing }
HDFSStore >> handleClass [
	
	^ HDFSFileHandle
]

{ #category : #printing }
HDFSStore >> humanReadableSIByteSize [
	
	^ 0
]

{ #category : #accessing }
HDFSStore >> initialize [
	host := 'localhost'.
	port := '9870'.
]

{ #category : #accessing }
HDFSStore >> initializeWithAuthStrategy: aStrategy [
	self initialize.
	authStrategy := aStrategy.
]

{ #category : #accessing }
HDFSStore >> initializeWithHost: aHost port: aPort [
	self initialize.
	host := aHost.
	port := aPort.
]

{ #category : #accessing }
HDFSStore >> initializeWithHost: aHost port: aPort strategy: aStrategy [
	self initialize.
	host := aHost.
	port := aPort.
	authStrategy := aStrategy.
]

{ #category : #printing }
HDFSStore >> nodeAt: anAbsolutePath ifPresent: aBlockClosure ifAbsent: aBlockClosure3 [
	| response |
	response := self request: anAbsolutePath operation: 'GETFILESTATUS'.
	^ response isSuccess
		ifTrue: [ aBlockClosure value: ((STONJSON fromString: response contents) at: 'FileStatus') ]
		ifFalse: [ aBlockClosure3 value ]
]

{ #category : #printing }
HDFSStore >> put: aPath operation: anOperation [
	self put: aPath operation: anOperation data: (ZnStringEntity text:'').
]

{ #category : #printing }
HDFSStore >> put: aPath operation: anOperation data: aData [
	^ ZnEasy
		put: ('http://' , host , ':' , port , '/webhdfs/v1' , aPath pathString , '?' , authStrategy authorizationSuffix , 'op=' , anOperation) data: aData.
]

{ #category : #abstract }
HDFSStore >> rename: sourcePath to: destinationPath [
	self put: sourcePath operation: ('RENAME&destination=' , destinationPath pathString).
]

{ #category : #printing }
HDFSStore >> request: aPath operation: anOperation [
	^ ZnEasy
		get: 'http://' , host , ':' , port , '/webhdfs/v1' , aPath pathString , '?' , authStrategy authorizationSuffix , 'op=' , anOperation
]
