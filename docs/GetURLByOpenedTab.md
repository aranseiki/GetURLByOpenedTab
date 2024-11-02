# Behavior Specification for `Get-BrowserInstance` function.

## Description
This specification details the expected behavior of the `Get-BrowserInstance` function, which searches for instances of a specific running browser and returns only those with an active window.

---

## Scenario 1: 'msedge' browser running with an active window
- **Given** that the `msedge` browser is running with an active window
- **When** the `Get-BrowserInstance` function is called with the `-ProcessName 'msedge'` parameter
- **Then** it should return the `msedge` process with an active window.

---

## Scenario 2: Browser 'msedge' is not running or has no active window
- **Given** that the browser `msedgeaaaaaa` is not running or no window is active
- **When** the `Get-BrowserInstance` function is called with the `-ProcessName 'msedgeaaaaaa'` parameter
- **Then** it should throw an exception that contains `msedgeaaaaaa` in the message.

---

