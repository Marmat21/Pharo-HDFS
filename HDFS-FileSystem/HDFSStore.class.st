Class {
	#name : #HDFSStore,
	#superclass : #FileSystemStore,
	#category : #'HDFS-FileSystem'
}

{ #category : #'instance-creation' }
HDFSStore class >> on: aLGitCommit [ 
	
	^ self new
		commit: aLGitCommit;
		yourself
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

{ #category : #'error signalling' }
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

{ #category : #printing }
HDFSStore >> nodeAt: anAbsolutePath ifPresent: aBlockClosure ifAbsent: aBlockClosure3 [
	| response |
	response := self request: anAbsolutePath operation: 'GETFILESTATUS'.
	^ response isSuccess
		ifTrue: [ aBlockClosure value: ((STONJSON fromString: response contents) at: 'FileStatus') ]
		ifFalse: [ aBlockClosure3 value ]
]

{ #category : #printing }
HDFSStore >> request: aPath operation: anOperation [
	^ ZnEasy get: 'http://localhost:9870/webhdfs/v1' , aPath pathString , '?op=' , anOperation
]
