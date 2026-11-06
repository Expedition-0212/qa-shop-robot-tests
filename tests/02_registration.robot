*** Settings ***
Documentation     User registration, including data-driven password validation.
Resource          ../resources/auth.resource
Suite Setup       Open QA Shop
Suite Teardown    Close All Browsers
Test Setup        Reset And Open Registration
Test Tags         registration

*** Test Cases ***
New User Can Register And Log In
    [Tags]    smoke
    ${username}=    Unique Username
    Register User    Asha Tester    ${username}@example.com    ${username}    Secure@123    Secure@123    accept_terms=${TRUE}
    Success Message Should Be    Account created! Please log in.
    Textfield Value Should Be    testid:username-input    ${username}
    Input Password    testid:password-input    Secure@123
    Click Element    testid:login-button
    Products Page Should Be Open
    Logged In User Should Be    ${username}

Empty Form Shows Every Required Field Error
    Click Element    testid:register-button
    Field Error Should Be    fullName           Full name is required
    Field Error Should Be    email              Email is required
    Field Error Should Be    username           Username is required
    Field Error Should Be    password           Password is required
    Field Error Should Be    confirmPassword    Please confirm your password
    Field Error Should Be    terms              You must accept the terms

Invalid Email Is Rejected
    Register User    email=not-an-email
    Field Error Should Be    email    Enter a valid email address

Duplicate Username Is Rejected
    Register User    username=STANDARD_USER
    Field Error Should Be    username    This username is already taken

Mismatched Passwords Are Rejected
    Register User    password=Secure@123    confirm=Secure@124
    Field Error Should Be    confirmPassword    Passwords do not match

Weak Password Is Rejected
    [Template]    Password Should Be Rejected
    short1!
    alllowercase1!
    NoNumbers!!
    NoSymbol123

*** Keywords ***
Reset And Open Registration
    Reset QA Shop
    Open Registration Page

Password Should Be Rejected
    [Arguments]    ${password}
    Register User    password=${password}
    Field Error Should Contain    password    8+ characters
