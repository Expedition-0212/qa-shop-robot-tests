*** Settings ***
Documentation     Checkout: totals, promo codes, validation, declined card and order history.
Resource          ../resources/auth.resource
Resource          ../resources/shop.resource
Suite Setup       Open QA Shop
Suite Teardown    Close All Browsers
Test Setup        Reset And Log In
Test Tags         checkout

*** Test Cases ***
Complete Purchase End To End
    [Tags]    smoke
    Add Products To Cart    ${HOODIE}    ${MUG}
    Start Checkout
    Submit Valid Shipping
    ${subtotal}=    Sum Prices    ${HOODIE}    ${MUG}
    &{exp}=    Order Summary Should Match    ${subtotal}
    Fill Payment
    Place Order
    ${order}=    Order Should Be Confirmed    ${exp}[total]
    Cart Badge Should Be    0
    Open My Orders
    Wait Until Element Is Visible    testid:order-${order}
    Element Should Contain    testid:order-${order}    ${exp}[total]

Shipping Is Charged Under $50 And FREESHIP Removes It
    Add Products To Cart    ${STICKERS}
    Start Checkout
    Submit Valid Shipping
    Order Summary Should Match    ${STICKERS}[price]
    Apply Promo Code    ${PROMO_FREESHIP}
    Wait Until Element Is Visible    testid:promo-applied
    Order Summary Should Match    ${STICKERS}[price]    ${PROMO_FREESHIP}

QA10 Gives 10 Percent Off And Invalid Codes Are Rejected
    Add Products To Cart    ${HOODIE}    ${MUG}
    Start Checkout
    Submit Valid Shipping
    Apply Promo Code    NOTACODE
    Field Error Should Be    promo    This promo code is not valid
    Apply Promo Code    qa10
    Wait Until Element Is Visible    testid:promo-applied
    ${subtotal}=    Sum Prices    ${HOODIE}    ${MUG}
    Order Summary Should Match    ${subtotal}    ${PROMO_10}

Shipping Form Is Validated
    Add Products To Cart    ${MUG}
    Start Checkout
    Click Element    testid:continue-to-payment
    FOR    ${field}    IN    firstName    lastName    address    city    zip
        Wait Until Element Is Visible    testid:error-${field}
    END
    Continue To Payment    firstName=Asha    lastName=Tester    address=1 Quality Way    city=Fremont    zip=1234
    Field Error Should Be    zip    ZIP code must be 5 digits

Declined Card Shows Error And No Order Is Placed
    Add Products To Cart    ${MUG}
    Start Checkout
    Submit Valid Shipping
    Fill Payment    card_number=${CARD_DECLINED}
    Place Order
    Error Message Should Contain    declined
    Cart Badge Should Be    1
    Open My Orders
    Wait Until Element Is Visible    testid:orders-empty

Card Details Are Validated
    Add Products To Cart    ${MUG}
    Start Checkout
    Submit Valid Shipping
    Fill Payment    card_number=${CARD_INVALID}    expiry=01/20    cvv=12
    Place Order
    Field Error Should Be    cardNumber    Enter a valid 16-digit card number
    Field Error Should Be    expiry        Card has expired
    Field Error Should Be    cvv           CVV must be 3 or 4 digits

*** Keywords ***
Reset And Log In
    Reset QA Shop
    Login As Standard User
