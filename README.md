# Example: Get Workitems Logs

Simple example how to get data from Robocorp cloud using API calls.
```robot
*** Tasks ***
Generate Csv Files
    Get Single Process Runs And Save As Csv
    Get Process Runs For Workspace And Save As Csv

Log processes in workspace
    ${API_data}    List processes in workspace
    ${API_Data}    Create Table    ${API_Data}
    FOR    ${process}    IN    @{API_data}
        Log    ${process}[name]    console=${True}
        Log    ${process}[id]    console=${True}
    END

Modify Single Process Run Data
    ${modified_data}    Get Single Process Run And Add Run Duration
    Write table to CSV    ${modified_data}    ${OUTPUT_DIR}${/}mod${CURRENT_DATE}.csv
```





## Learning materials

- [Robocorp Developer Training Courses](https://robocorp.com/docs/courses)
- [Documentation links on Robot Framework](https://robocorp.com/docs/languages-and-frameworks/robot-framework)
- [Example bots in Robocorp Portal](https://robocorp.com/portal)
