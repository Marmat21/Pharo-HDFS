Class {
	#name : #BaselineOfHDFSFileSystem,
	#superclass : #BaselineOf,
	#category : #BaselineOfHDFSFileSystem
}

{ #category : #baselines }
BaselineOfHDFSFileSystem class >> corePackages [
	| groups |

	groups := self packagesOfGroupNamed: 'core-traits'.
	^ groups flatCollect: [ :e | self packagesOfGroupNamed: e ].
]

{ #category : #baselines }
BaselineOfHDFSFileSystem >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'HDFS-FileSystem' ].
]
