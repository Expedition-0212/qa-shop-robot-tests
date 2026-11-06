*** Variables ***
${PASSWORD}             Test@123
${STANDARD_USER}        standard_user
${LOCKED_USER}          locked_user
${SLOW_USER}            slow_user

${CARD_APPROVED}        4111 1111 1111 1111
${CARD_DECLINED}        4000 0000 0000 0002
${CARD_INVALID}         1234 5678 9012 3456

${PROMO_10}             QA10
${PROMO_FREESHIP}       FREESHIP

&{HOODIE}               id=1    name=Bug Hunter Hoodie            price=49.99
&{MUG}                  id=2    name=Assertion Coffee Mug         price=14.99
&{STRESS_BALL}          id=3    name=Flaky Test Stress Ball       price=9.99
&{STICKERS}             id=5    name=Selector Sticker Pack        price=6.99

&{SHIPPING}             firstName=Asha    lastName=Tester    address=1 Quality Way    city=Fremont    zip=94536
