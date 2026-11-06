*** Settings ***
Documentation     Product listing, sorting, search and add/remove.
Resource          ../resources/auth.resource
Resource          ../resources/shop.resource
Suite Setup       Open QA Shop
Suite Teardown    Close All Browsers
Test Setup        Reset And Log In
Test Tags         products

*** Test Cases ***
All Products Are Listed A To Z By Default
    @{names}=    Get Product Names
    Length Should Be    ${names}    8
    Should Be Sorted    ${names}

Sort By Name Z To A
    Sort Products By    za
    @{names}=    Get Product Names
    Should Be Sorted    ${names}    descending=${TRUE}

Sort By Price Low To High
    Sort Products By    lohi
    @{prices}=    Get Product Prices
    Should Be Sorted    ${prices}

Sort By Price High To Low
    Sort Products By    hilo
    @{prices}=    Get Product Prices
    Should Be Sorted    ${prices}    descending=${TRUE}

Search Filters Products By Name
    Search Products    mug
    @{names}=    Get Product Names
    Should Be Equal    ${names}    ${{ ['${MUG}[name]'] }}
    Search Products    does-not-exist
    Wait Until Element Is Visible    testid:no-results

Add And Remove Updates The Cart Badge
    [Tags]    smoke
    Cart Badge Should Be    0
    Add Products To Cart    ${HOODIE}    ${MUG}
    Cart Badge Should Be    2
    Click Element    testid:remove-from-cart-${HOODIE}[id]
    Wait Until Element Is Visible    testid:add-to-cart-${HOODIE}[id]
    Cart Badge Should Be    1

*** Keywords ***
Reset And Log In
    Reset QA Shop
    Login As Standard User
