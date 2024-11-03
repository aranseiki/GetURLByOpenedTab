# Behavior Specification for `Get-AutomatedBrowserWindowInstance` function.

## Description
This specification details the expected behavior of the `Get-AutomatedBrowserWindowInstance` function, which receive an instance of a specific running browser and returns an automated browser window object.

---

## Scenario 1: 'msedge' browser running with an active window
- **Given** that the `msedge` browser is running with an active window
- **When** the `Get-AutomatedBrowserWindowInstance` function is called with a valid browser process instance as value of the `-BrowserProcess` parameter
- **Then** it should return an automated window linked to this browser process.

---

## Scenario 2: Browser 'msedge' is not running or has no active window
- **Given** that the browser `msedge` is not running or no window is active
- **When** the `Get-AutomatedBrowserWindowInstance` function is called with an invalid or inactive browser process instance as the `-BrowserProcess` parameter
- **Then** it should throw an exception containing the keywords `FromHandle` and `Unrecognized error` in the message.

---

