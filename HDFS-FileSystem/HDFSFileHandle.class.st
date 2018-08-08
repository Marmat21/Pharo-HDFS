Class {
	#name : #HDFSFileHandle,
	#superclass : #FileSystemHandle,
	#category : #'HDFS-FileSystem'
}

{ #category : #streams }
HDFSFileHandle >> binaryReadStream [
	
	^ ZnBufferedReadStream on: (HDFSReadStream on: reference)
]
