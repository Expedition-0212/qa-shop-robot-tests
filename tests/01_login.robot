*** Settings ***
Documentation     Login and logout scenarios for the QA Shop practice app.
Resource          ../resources/auth.resource
Suite Setup       Open QA Shop
Suite Teardown    Close All Browsers
Test Setup        Reset QA Shop
Test Tags         login

*** Test Cases ***
Standard User Can Log In And Log Out
    [Tags]    smoke
    Login As Standard User
    Logged In User Should Be    ${STANDARD_USER}
    Logout

Empty Form Shows Required Field Errors
    Click Element    testid:login-button
    Field Error Should Be    username    Username is required
    Field Error Should Be    password    Password is required

Wrong Password Is Rejected
    Login As    ${STANDARD_USER}    WrongPass1!
    Error Message Should Be    Username and password do not match any user

Locked User Cannot Log In
    Login As    ${LOCKED_USER}    ${PASSWORD}
    Error Message Should Be    Sorry, this user has been locked out
    Page Should Not Contain Element    testid:logged-in-user

Slow User Logs In After A Delay
    [Documentation]    Uses an explicit wait condition instead of a fixed Sleep.
    Login As    ${SLOW_USER}    ${PASSWORD}
    Wait Until Element Is Visible    testid:loading-spinner
    Products Page Should Be Open    timeout=10s
    Logged In User Should Be    ${SLOW_USER}
