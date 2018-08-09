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

{ #category : #abstract }
HDFSStore >> basicIsSymlink: aNode [
	
	^ (aNode at: 'type') = 'SYMLINK'.
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

{ #category : #'as yet unclassified' }
HDFSStore >> createFile: anAbsolutePath [ 
	| response location client |
	response := self put: anAbsolutePath operation: 'CREATE&noredirect=true'.
	location := (STONJSON fromString: response entity contents) at: 'Location'.
	client := ZnClient new.
	response := client put: location contents: #() ;  put: location contents: #()  ; response.

]

{ #category : #'as yet unclassified' }
HDFSStore >> createFile: anAbsolutePath withContent: content [
	| response location client |
	response := self put: anAbsolutePath operation: 'CREATE&noredirect=true'.
	location := (STONJSON fromString: response entity contents) at: 'Location'.
	client := ZnClient new.
	^ client put: location contents: content ;  put: location contents: #()  ; response.

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

{ #category : #public }
HDFSStore >> openFileStream: path writable: writable [
	self subclassResponsibility
]

{ #category : #printing }
HDFSStore >> post: aPath operation: anOperation [
	^ ZnEasy
		post: ('http://' , host , ':' , port , '/webhdfs/v1' , aPath pathString , '?' , authStrategy authorizationSuffix , 'op=' , anOperation) data: (ZnStringEntity text: '').
]

{ #category : #printing }
HDFSStore >> post: aPath operation: anOperation data: data [
	^ ZnEasy
		post: ('http://' , host , ':' , port , '/webhdfs/v1' , aPath pathString , '?' , authStrategy authorizationSuffix , 'op=' , anOperation) data: data.
]

{ #category : #'as yet unclassified' }
HDFSStore >> post: anAbsolutePath operation: anOperation follow: aBoolean [
	| client url |
	^ aBoolean
		ifTrue: [ self post: anAbsolutePath operation: anOperation ]
		ifFalse: [ client := ZnClient new.
			url := 'http://' , host , ':' , port , '/webhdfs/v1' , anAbsolutePath pathString , '?' , authStrategy authorizationSuffix
				, 'op=' , anOperation.
			client
				url: url;
				followRedirects: false;
				entity: (ZnStringEntity text: '');
				post;
				response ]
]

{ #category : #printing }
HDFSStore >> put: aPath operation: anOperation [
	^self put: aPath operation: anOperation data: (ZnStringEntity text:'').
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
