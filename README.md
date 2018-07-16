# cds-memleak
This project was done to reveal a memory leak in a widely used component in Delphi called TClientDataset.  

# Motivation
The company I work for uses TClientDatasets everywhere.  We wrote lots of back end tools to support our data delivery systems.  One tool is a custom Windows service which has a TClientDatasets dropped on the Service data module.  This service runs 24/7.  We started noticing the memory would gradually climb up to a max point then the service would lock up.  After restarting the service it would do this again.  We obviously thought our code had a bug somewhere so after hours and hours of investigation, we came to the conclusion that we need to test TClientdatasets in a stand alone test harness since everything pointed to this as the culprit.

# Source
The project was created with Delphi XE7.  It was further tested in Delphi 10.2 Tokyo which still has the bug in it.

# Technical documentation
[MemDatasetLeak.docx](./Documentation/MemDatasetLeak.docx)

# Sample test
Test Params: Record Count=1000. Field count=8.  Consecutive test count=1000.  Random Edit count=50. 
Random Delete count=50. LogChanges=FALSE

| Delete 50 random | Edit 50 random | Go to first record  |            |
|     records      |    records     |     after test      |  Results   |
|:----------------:|:--------------:|:-------------------:|:----------:|
|      FALSE       |     FALSE      |        FALSE        |            |
|      FALSE       |     FALSE      |        TRUE         |   LEAK     |
|      FALSE       |     TRUE       |        FALSE        |            |
|      FALSE       |     TRUE       |        TRUE         |   LEAK     |
|      TRUE        |     FALSE      |        FALSE        |   LEAK     |
|      TRUE        |     FALSE      |        TRUE         |   LEAK     |
|      TRUE        |     TRUE       |        FALSE        |   LEAK     |
|      TRUE        |     TRUE       |        TRUE         |   LEAK     |

# Binaries
comming soon

# Authors
Chris McClenny<br>
Dave Clark
