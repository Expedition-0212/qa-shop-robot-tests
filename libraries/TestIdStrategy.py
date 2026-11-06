"""Adds a `testid:` locator strategy to SeleniumLibrary.

    Click Element    testid:login-button
is equivalent to
    Click Element    css:[data-testid="login-button"]
"""


def find_by_test_id(browser, locator, tag=None, constraints=None):
    return browser.find_elements("css selector", f'[data-testid="{locator}"]')
