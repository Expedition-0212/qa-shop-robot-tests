*** Settings ***
Documentation     Browser setup, app reset and shared assertions.
Library           SeleniumLibrary    timeout=10s    run_on_failure=Capture Page Screenshot
Library           Collections
Library           ../libraries/TestIdStrategy.py
Library           ../libraries/ShopHelpers.py
Resource          test_data.resource

*** Variables ***
${BASE_URL}       https://pramodkoli.in/
${BROWSER}        chrome
${HEADLESS}       ${TRUE}
${DRIVER_PATH}    ${EMPTY}

*** Keywords ***
Open QA Shop
    [Documentation]    Opens the Practice App tab in a new browser and registers the `testid:` locator strategy.
    ${options}=    Browser Options
    IF    $DRIVER_PATH
        Open Browser    ${BASE_URL}#practice    ${BROWSER}    options=${options}    service=executable_path='${DRIVER_PATH}'
    ELSE
        Open Browser    ${BASE_URL}#practice    ${BROWSER}    options=${options}
    END
    # Registered once per run; later suites reuse it.
    Run Keyword And Ignore Error    Add Location Strategy    testid    Find By Test Id    persist=True
    Wait Until Element Is Visible    testid:practice-app

Browser Options
    IF    '${BROWSER}'.lower() in ('firefox', 'ff', 'headlessfirefox')
        IF    ${HEADLESS}    RETURN    add_argument("-headless");add_argument("--width=1440");add_argument("--height=1400")
        RETURN    add_argument("--width=1440");add_argument("--height=1400")
    END
    IF    ${HEADLESS}    RETURN    add_argument("--headless=new");add_argument("--window-size=1440,1400");add_argument("--no-sandbox");add_argument("--disable-dev-shm-usage")
    RETURN    add_argument("--window-size=1440,1400")

Reset QA Shop
    [Documentation]    Clears all app data (users, carts, orders, session) so every test starts clean.
    Go To    ${BASE_URL}#practice
    Execute Javascript    localStorage.clear(); sessionStorage.clear();
    Reload Page
    Wait Until Element Is Visible    testid:login-button

Error Message Should Be
    [Arguments]    ${text}
    Wait Until Element Is Visible    testid:error-message
    Element Text Should Be    testid:error-message    ${text}

Error Message Should Contain
    [Arguments]    ${text}
    Wait Until Element Is Visible    testid:error-message
    Element Should Contain    testid:error-message    ${text}

Success Message Should Be
    [Arguments]    ${text}
    Wait Until Element Is Visible    testid:success-message
    Element Text Should Be    testid:success-message    ${text}

Field Error Should Be
    [Arguments]    ${field}    ${text}
    Wait Until Element Is Visible    testid:error-${field}
    Element Text Should Be    testid:error-${field}    ${text}

Field Error Should Contain
    [Arguments]    ${field}    ${text}
    Wait Until Element Is Visible    testid:error-${field}
    Element Should Contain    testid:error-${field}    ${text}

Cart Badge Should Be
    [Arguments]    ${count}
    IF    ${count} == 0
        Page Should Not Contain Element    testid:cart-badge
    ELSE
        Wait Until Element Is Visible    testid:cart-badge
        Element Text Should Be    testid:cart-badge    ${count}
    END
