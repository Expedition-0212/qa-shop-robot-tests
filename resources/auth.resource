*** Settings ***
Documentation     Login, logout and registration keywords.
Resource          common.resource

*** Keywords ***
Login As
    [Arguments]    ${username}    ${password}
    Input Text        testid:username-input    ${username}
    Input Password    testid:password-input    ${password}
    Click Element     testid:login-button

Login As Standard User
    Login As    ${STANDARD_USER}    ${PASSWORD}
    Products Page Should Be Open

Products Page Should Be Open
    [Arguments]    ${timeout}=10s
    Wait Until Element Is Visible    testid:product-list    timeout=${timeout}

Logged In User Should Be
    [Arguments]    ${username}
    Element Should Contain    testid:logged-in-user    ${username}

Logout
    Click Element    testid:logout-button
    Wait Until Element Is Visible    testid:login-button

Open Registration Page
    Click Element    testid:go-to-register
    Wait Until Element Is Visible    testid:register-form

Register User
    [Arguments]    ${full_name}=${EMPTY}    ${email}=${EMPTY}    ${username}=${EMPTY}
    ...            ${password}=${EMPTY}    ${confirm}=${EMPTY}    ${accept_terms}=${FALSE}
    Input Text    testid:fullName-input    ${full_name}
    Input Text    testid:email-input       ${email}
    Input Text    testid:username-input    ${username}
    Input Password    testid:password-input           ${password}
    Input Password    testid:confirmPassword-input    ${confirm}
    IF    ${accept_terms}    Select Checkbox    testid:terms-checkbox
    Click Element    testid:register-button
