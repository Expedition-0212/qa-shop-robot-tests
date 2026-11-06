# QA Shop — Robot Framework E2E Tests

End-to-end test suite for the **QA Shop practice app** on [pramodkoli.in](https://pramodkoli.in/#practice), written in **Robot Framework + SeleniumLibrary** with reusable, readable keywords.

It is a ready-made example for learning keyword-driven UI automation: login, registration, product sorting and search, cart, checkout, promo codes, payment validation and order history.

![Tests](https://github.com/Expedition-0212/qa-shop-robot-tests/actions/workflows/robot.yml/badge.svg)

## What's covered (28 tests)

| Suite | Scenarios |
|---|---|
| `01_login` | valid login/logout, empty fields, wrong password, locked user, slow user (explicit waits, no `Sleep`) |
| `02_registration` | register then log in, required fields, invalid email, duplicate username, mismatched passwords, weak passwords (`[Template]`, data-driven) |
| `03_products` | default A–Z order, sort Z–A / price ↑ / price ↓, search, add/remove and cart badge |
| `04_cart` | subtotal, quantity changes, remove to zero, empty state, cart persists across logout |
| `05_checkout` | full purchase with total verification, shipping fee + `FREESHIP`, `QA10` discount, shipping-form validation, declined card, card/expiry/CVV validation |

## Project structure

```
├── libraries/
│   ├── TestIdStrategy.py   # adds the `testid:` locator → [data-testid="..."]
│   └── ShopHelpers.py      # money format, expected totals, unique usernames, sort checks
├── resources/
│   ├── common.resource     # browser setup, app reset, shared assertions
│   ├── auth.resource       # login, logout, registration keywords
│   ├── shop.resource       # products, cart, checkout, orders keywords
│   └── test_data.resource  # users, cards, promo codes, products, shipping data
├── tests/                  # 01_login … 05_checkout suites
├── requirements.txt
└── .github/workflows/robot.yml   # CI on push, PR, weekly and on demand
```

## Run it

```bash
python -m venv .venv && source .venv/bin/activate    # Windows: .venv\Scripts\activate
pip install -r requirements.txt

robot --outputdir results tests                      # all tests, headless Chrome
robot --outputdir results --include smoke tests      # smoke tests only
robot --outputdir results -v HEADLESS:False tests    # watch the browser
robot --outputdir results -v BROWSER:firefox tests   # run on Firefox
robot --outputdir results tests/05_checkout.robot    # a single suite
```

Open `results/report.html` and `results/log.html` to see the results (screenshots are captured on failure).

Selenium 4 downloads the right browser driver automatically. Chrome or Firefox must be installed.

### Variables

| Variable | Default | Purpose |
|---|---|---|
| `BASE_URL` | `https://pramodkoli.in/` | Site hosting the app. Tests open `BASE_URL#practice`. |
| `BROWSER` | `chrome` | `chrome`, `firefox` or `edge` |
| `HEADLESS` | `True` | `False` to see the browser |
| `DRIVER_PATH` | *(auto)* | Path to a specific chromedriver, if needed |

## Practices shown

- **Keyword-driven design**: tests read like plain English; logic lives in resource files
- **Custom locator strategy** (`testid:login-button`) for stable, readable locators
- **Clean state per test**: `Reset QA Shop` clears browser storage, so tests are independent
- **Explicit waits** (`Wait Until Element Is Visible`); no fixed `Sleep`
- **Data-driven tests** with `[Template]`
- **Python helper library** for calculations: expected tax, discount and shipping come from business rules, not hard-coded values
- **Tags** (`smoke`, `login`, `cart`, …) for selective runs; **CI** with uploaded reports

## Test data

| Users (password `Test@123`) | Cards | Promo codes |
|---|---|---|
| `standard_user`, `locked_user`, `slow_user` | `4111 1111 1111 1111` approved · `4000 0000 0000 0002` declined | `QA10` (10% off) · `FREESHIP` |

---
Practice the same flows with Playwright: [qa-shop-playwright-tests](https://github.com/Expedition-0212/qa-shop-playwright-tests).
