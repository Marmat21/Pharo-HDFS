Class {
	#name : #HDFSFileHandle,
	#superclass : #FileSystemHandle,
	#category : #'HDFS-FileSystem'
}

{ #category : #streams }
HDFSFileHandle >> binaryReadStream [
	
	^ ZnBufferedReadStream on: (HDFSReadStream on: reference)
]

{ #category : #streams }
HDFSFileHandle >> binaryWriteStream [
	^ HDFSWriteStream on: reference
]

{ #category : #streams }
HDFSFileHandle >> binaryWriteStreamOn: path [
	
	^ ZnBufferedWriteStream on: (HDFSWriteStream on: reference)
]

{ #category : #public }
HDFSFileHandle >> open [
	"DO NOTHING"
]
