*** Settings ***
Documentation     Cart quantities, totals, removal and persistence.
Resource          ../resources/auth.resource
Resource          ../resources/shop.resource
Suite Setup       Open QA Shop
Suite Teardown    Close All Browsers
Test Setup        Log In With Three Items In Cart
Test Tags         cart

*** Test Cases ***
Cart Shows Items And Subtotal
    Page Should Contain Element    testid:cart-item-${HOODIE}[id]
    Page Should Contain Element    testid:cart-item-${MUG}[id]
    Page Should Contain Element    testid:cart-item-${STRESS_BALL}[id]
    ${subtotal}=    Sum Prices    ${HOODIE}    ${MUG}    ${STRESS_BALL}
    Cart Subtotal Should Be    ${subtotal}

Changing Quantity Updates Totals
    Increase Quantity    ${MUG}    times=2
    Element Text Should Be    testid:qty-value-${MUG}[id]    3
    ${mugs}=    Sum Prices    ${MUG}    2=3
    ${line}=    Money    ${mugs}
    Element Text Should Be    testid:cart-item-total-${MUG}[id]    ${line}
    ${subtotal}=    Sum Prices    ${HOODIE}    ${MUG}    ${STRESS_BALL}    2=3
    Cart Subtotal Should Be    ${subtotal}
    Cart Badge Should Be    5

Decreasing Quantity To Zero Removes The Item
    Decrease Quantity    ${STRESS_BALL}
    Page Should Not Contain Element    testid:cart-item-${STRESS_BALL}[id]
    Cart Badge Should Be    2

Removing All Items Shows Empty Cart
    FOR    ${p}    IN    ${HOODIE}    ${MUG}    ${STRESS_BALL}
        Remove From Cart    ${p}
    END
    Element Should Be Visible    testid:cart-empty
    Element Should Be Disabled    testid:checkout-button

Cart Persists After Logout And Login
    Logout
    Login As Standard User
    Cart Badge Should Be    3

*** Keywords ***
Log In With Three Items In Cart
    Reset QA Shop
    Login As Standard User
    Add Products To Cart    ${HOODIE}    ${MUG}    ${STRESS_BALL}
    Open Cart
