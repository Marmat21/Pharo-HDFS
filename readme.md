# PHARO-HDFS

This repository provides an API to access, create and delete files on HDFS.

## Setup
This API uses the WebHDFS REST API to access the data on the file system.
Hence, the following option should be added to your `hdfs-site.xml`
```
<property>
    <name>dfs.webhdfs.enabled</name>
    <value>true</value>
    <description>Enable webHDFS API</description>
</property>
```

In some versions of HDFS the _Append_ operation is disabled by default.

If you wish to use this operator to append data to existing files in the file system, insert the following in the same `hdfs-site.xml`

```
<property>
    <name>dfs.support.append</name>
    <value>true</value>
    <description>Enable append support</description>
</property>

```

## Initialization

### Security Disabled
Get a FileSystem instance                   := `FileSystem hdfs`

Get a FileSystem instance specifying user   := `FileSystem hdfsWithUser:<username>`

### Security Enabled
The HDFS WEBApi allows to use an _Hadoop delegation Token_ or the _Kerberos_ authentication.
In this version of our API, only the _Hadoop delegation Token_ can be used.

Get a FileSystem instance using Hadoop delegation Token := `FileSystem hdfsWithToken:<token>`

### Specify Host and Port
By default the API uses _localhost:9870_ as address of HDFS.
It is possible to specify a different host and port during the initialization of the host.
In this case, the following code should be executed:
```
hdfsStore   := HDFSStore host:<hostName> port:<port>.
fileSystem  := FileSystem store: hdfsStore.
```

## API
The Pharo-HDFS API implements the FileSystem API of Pharo.
As for the default FileSystem, the following operations are supported:

```
fileSystem createDirectory:<path>
fileSystem delete:<path>
fileSystem rename:<oldName> to: <newName>
```

Files can be accessed using FileReference(s).
```
fileReference := fileSystem / path / of / the / file. "get the file reference"
fileReference contents. "read the contents of the file"
fileReference readStream. "get a ReadStream on the file"
```

# Writing on a file
The HDFS API does not allow to change the content of a File.
The only allowed operation is to _Append_.



