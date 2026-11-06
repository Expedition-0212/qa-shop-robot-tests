*** Settings ***
Documentation     Products, cart, checkout and orders keywords.
Resource          common.resource

*** Keywords ***
# ---------- Products ----------
Add Products To Cart
    [Arguments]    @{products}
    FOR    ${p}    IN    @{products}
        Click Element    testid:add-to-cart-${p}[id]
        Wait Until Element Is Visible    testid:remove-from-cart-${p}[id]
    END

Sort Products By
    [Documentation]    az | za | lohi | hilo
    [Arguments]    ${option}
    Select From List By Value    testid:sort-select    ${option}

Get Product Names
    @{els}=    Get WebElements    css:[data-testid^="product-name-"]
    @{names}=    Create List
    FOR    ${el}    IN    @{els}
        Append To List    ${names}    ${el.text}
    END
    RETURN    ${names}

Get Product Prices
    @{els}=    Get WebElements    css:[data-testid^="product-price-"]
    @{texts}=    Create List
    FOR    ${el}    IN    @{els}
        Append To List    ${texts}    ${el.text}
    END
    ${prices}=    Prices From Texts    ${texts}
    RETURN    ${prices}

Search Products
    [Arguments]    ${text}
    Input Text    testid:search-input    ${text}

# ---------- Cart ----------
Open Cart
    Click Element    testid:nav-cart
    Wait Until Element Is Visible    testid:checkout-button

Increase Quantity
    [Arguments]    ${product}    ${times}=1
    FOR    ${i}    IN RANGE    ${times}
        Click Element    testid:qty-plus-${product}[id]
    END

Decrease Quantity
    [Arguments]    ${product}    ${times}=1
    FOR    ${i}    IN RANGE    ${times}
        Click Element    testid:qty-minus-${product}[id]
    END

Remove From Cart
    [Arguments]    ${product}
    Click Element    testid:cart-remove-${product}[id]
    Wait Until Page Does Not Contain Element    testid:cart-item-${product}[id]

Cart Subtotal Should Be
    [Arguments]    ${amount}
    ${expected}=    Money    ${amount}
    Element Text Should Be    testid:cart-subtotal    ${expected}

# ---------- Checkout ----------
Start Checkout
    Open Cart
    Click Element    testid:checkout-button
    Wait Until Element Is Visible    testid:shipping-form

Fill Shipping
    [Arguments]    &{data}
    FOR    ${field}    ${value}    IN    &{data}
        Input Text    testid:${field}-input    ${value}
    END

Continue To Payment
    [Arguments]    &{data}
    Fill Shipping    &{data}
    Click Element    testid:continue-to-payment

Submit Valid Shipping
    Continue To Payment    &{SHIPPING}
    Wait Until Element Is Visible    testid:payment-form

Fill Payment
    [Arguments]    ${card_name}=Asha Tester    ${card_number}=${CARD_APPROVED}    ${expiry}=${EMPTY}    ${cvv}=123
    IF    not $expiry
        ${expiry}=    Future Expiry
    END
    Input Text    testid:cardName-input      ${card_name}
    Input Text    testid:cardNumber-input    ${card_number}
    Input Text    testid:expiry-input        ${expiry}
    Input Text    testid:cvv-input           ${cvv}

Apply Promo Code
    [Arguments]    ${code}
    Input Text    testid:promo-input    ${code}
    Click Element    testid:apply-promo

Place Order
    Click Element    testid:place-order

Order Summary Should Match
    [Documentation]    Checks the summary against totals computed from the app's pricing rules.
    [Arguments]    ${subtotal}    ${promo}=${EMPTY}
    &{exp}=    Expected Totals    ${subtotal}    ${promo}
    Element Text Should Be    testid:summary-subtotal    ${exp}[subtotal]
    Element Text Should Be    testid:summary-shipping    ${exp}[shipping]
    Element Text Should Be    testid:summary-tax         ${exp}[tax]
    Element Text Should Be    testid:summary-total       ${exp}[total]
    IF    $promo.upper() == 'QA10'
        Element Text Should Be    testid:summary-discount    −${exp}[discount]
    END
    RETURN    ${exp}

Order Should Be Confirmed
    [Arguments]    ${expected_total}
    Wait Until Element Is Visible    testid:order-confirmation
    ${number}=    Get Text    testid:order-number
    Should Match Regexp    ${number}    ^ORD-\\d{6}$
    Element Text Should Be    testid:order-total    ${expected_total}
    RETURN    ${number}

Open My Orders
    Click Element    testid:nav-orders
