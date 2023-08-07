# Example app
This example covers this scenario:
1. User login to app with deriv token or as guest.
2. User selects a symbol/market from a selector and see its live price from deriv api.
3. User can optionally view market price in chart page, by tapping `View Chart` in home page.

### Additional scenarios:
- Feature flags
- Reconnect mechanism for websocket
- Error handling
- Remembers last logged in user on fresh start
- Uses modern navigation package (GoRouter)
