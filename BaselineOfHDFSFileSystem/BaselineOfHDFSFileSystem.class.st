Class {
	#name : #BaselineOfHDFSFileSystem,
	#superclass : #BaselineOf,
	#category : #BaselineOfHDFSFileSystem
}

{ #category : #baselines }
BaselineOfHDFSFileSystem >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'HDFS-FileSystem' ].
]
