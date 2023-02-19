*** Settings ***
Documentation       Robot with an purpose of getting
...                 cloud workitem logs

Library             RPA.Database
Library             RPA.Tables
Library             DateTime
Library             String
Library             RPA.Robocorp.Process
Library             Collections
Resource            cloud_api.robot

Suite Setup         Set Up Suite
Suite Teardown      Clean Up Suite


*** Variables ***
${API BASE URL}     http://localhost:3002/    ##https://api.eu1.robocorp.com/process-v1/
${WORKSPACE_ID}     17815069-25a7-48c0-938c-8d3da0142d64
${PROCESS_ID}       53f81879-833f-4841-8cd1-ef9266dba562


*** Tasks ***
Generate Csv Files
    Log To Console    \n
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


*** Keywords ***
Get Single Process Runs And Save As Csv
    ${process_data}    List process runs (for a process)
    ${API_Data}    Create Table    ${process_data}
    Write table to CSV    ${API_Data}    ${OUTPUT_DIR}${/}process_runs_${CURRENT_DATE}.csv

Get Process Runs For Workspace And Save As Csv
    ${process_data}    List process runs (for a workspace)
    ${API_Data}    Create Table    ${process_data}
    Write table to CSV    ${API_Data}    ${OUTPUT_DIR}${/}workspace_runs_${CURRENT_DATE}.csv

Set Current Date
    ${CURRENT_DATE}    Get Current Date    local    result_format=%d_%m_%Y
    Set Suite Variable    $CURRENT_DATE

Clean Up Suite
    [Documentation]    Keywords to run after all tasks are
    ...    completed or failed
    Delete All Sessions

Set Up Suite
    [Documentation]    Keywords to run before any tasks
    ...    are run
    Create Robocorp Cloud Session
    Set Current Date

Add Duration Time To Runs Data
    [Arguments]    ${process_datatable}
    Add table column    ${process_datatable}    name=Duration
    FOR    ${index}    ${element}    IN ENUMERATE    @{process_datatable}
        IF    "${element}[endTs]" != "${None}"
            ${duration}    Subtract Date From Date    ${element}[endTs]    ${element}[startTs]
            Set Table Cell    ${process_datatable}    ${index}    Duration    ${duration}
        END
    END
    Write table to CSV    ${process_datatable}    ${OUTPUT_DIR}${/}mod_data.csv
    RETURN    ${process_datatable}

Get Single Process Run And Add Run Duration
    ${process_data}    List process runs (for a process)
    ${API_Data}    Create Table    ${process_data}
    ${API_Data}    Add Duration Time To Runs Data    ${API_Data}
    RETURN    ${API_Data}
