*** Settings ***
Library     RPA.JSON
Library     RPA.HTTP
Library     RPA.Robocorp.Vault


*** Variables ***
${API BASE URL}     http://localhost:3002/
${WORKSPACE_ID}
${PROCESS_ID}


*** Keywords ***
Create Robocorp Cloud Session
    [Documentation]    Create session for cloud api using access token
    ${cloud_api_key}    Get Secret    API_access
    &{auth}    Create Dictionary    Authorization=${cloud_api_key}[Authorization]
    Create Session    ROBOCLOUD
    ...    ${API BASE URL}
    ...    headers=${auth}
    ...    disable_warnings=True

List process runs (for a process)
    [Arguments]    ${limit}=10
    ${resp}    GET On Session
    ...    ROBOCLOUD
    ...    url=workspaces/${WORKSPACE_ID}/processes/${PROCESS_ID}/runs?limit=${limit}
    ...    expected_status=200
    ${process_data}    Get value from JSON    ${resp.json()}    $.data
    RETURN    ${process_data}

List process runs (for a workspace)
    [Arguments]    ${limit}=10
    ${resp}    GET On Session
    ...    ROBOCLOUD
    ...    url=workspaces/${WORKSPACE_ID}/pruns?limit=${limit}
    ...    expected_status=200
    ${process_data}    Set Variable    ${resp.json()}
    RETURN    ${process_data}

List processes in workspace
    ${resp}    GET On Session
    ...    ROBOCLOUD
    ...    url=workspaces/${WORKSPACE_ID}/processes?
    ...    expected_status=200
    ${process_data}    Get value from JSON    ${resp.json()}    $.data
    RETURN    ${process_data}

Get Process Id
    [Arguments]    ${process_name}
    ${resp}    GET On Session
    ...    ROBOCLOUD
    ...    url=workspaces/${WORKSPACE_ID}/processes?
    ...    expected_status=200
    ${process_data}    Get value from JSON
    ...    ${resp.json()}
    ...    $.data[?(@.name=="Workitems")].id
    RETURN    ${process_data}
