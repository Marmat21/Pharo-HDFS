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

## Functionality
