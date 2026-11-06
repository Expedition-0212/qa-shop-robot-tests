"""Helper keywords: money formatting, expected totals (mirroring the app's pricing rules),
unique usernames and card expiry dates."""
import random
import time
from datetime import date

TAX_RATE = 0.0825
SHIPPING_FEE = 5.99
FREE_SHIPPING_OVER = 50


def _r2(n):
    return round(float(n) + 1e-9, 2)


def money(amount):
    """Formats a number the way the app shows it: 12.5 -> $12.50"""
    return f"${float(amount):.2f}"


def expected_totals(subtotal, promo=""):
    """Returns a dictionary with discount, shipping, tax and total for a subtotal and optional promo code."""
    sub = float(subtotal)
    promo = (promo or "").upper()
    discount = _r2(sub * 0.10) if promo == "QA10" else 0.0
    shipping = 0.0 if promo == "FREESHIP" or sub - discount >= FREE_SHIPPING_OVER else SHIPPING_FEE
    tax = _r2((sub - discount) * TAX_RATE)
    total = _r2(sub - discount + shipping + tax)
    return {"subtotal": money(sub), "discount": money(discount), "shipping": "Free" if shipping == 0 else money(shipping),
            "tax": money(tax), "total": money(total)}


def unique_username(prefix="rf"):
    """A username that is unique for every run."""
    return f"{prefix}_{int(time.time() * 1000) % 10**9}{random.randint(10, 99)}"


def future_expiry(years=2):
    """Card expiry `years` from today in MM/YY."""
    d = date.today()
    return f"{d.month:02d}/{(d.year + years) % 100:02d}"


def prices_from_texts(texts):
    """['$9.99', '$12.49'] -> [9.99, 12.49]"""
    return [float(t.replace("$", "").strip()) for t in texts]


def should_be_sorted(values, descending=False):
    """Fails unless the list is sorted (strings compare case-insensitively)."""
    key = (lambda v: v.lower()) if values and isinstance(values[0], str) else None
    expected = sorted(values, key=key, reverse=bool(descending) and str(descending).lower() != "false")
    if list(values) != expected:
        raise AssertionError(f"List is not sorted.\nActual:   {list(values)}\nExpected: {expected}")


def sum_prices(*products, **quantities):
    """Adds up product prices. Optional quantities by product id, e.g.
    `Sum Prices    ${HOODIE}    ${MUG}    2=3` means one hoodie plus three mugs."""
    total = 0.0
    for p in products:
        qty = int(quantities.get(str(p["id"]), 1))
        total += float(p["price"]) * qty
    return _r2(total)
