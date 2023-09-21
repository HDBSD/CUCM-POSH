<#
.SYNOPSIS
This enum defines different call forward types for Cisco Call Manager (CUCM).

.DESCRIPTION
The CallForwardTypes enum provides a list of call forward types that can be used
when interacting with CUCM through the CUCM-POSH module.

Each enum value represents a specific call forward scenario.

# Values:
- All: Forward all calls.
- Busy: Forward calls when the line is busy.
- BusyInt: Forward calls when the line is busy, international destinations.
- NoAnswer: Forward calls when there is no answer.
- NoAnswerInt: Forward calls when there is no answer, international destinations.
- NoCoverage: Forward calls when there is no coverage.
- OnFailure: Forward calls on failure.
- AlternateParty: Forward calls to an alternate party.
- NotRegistered: Forward calls when the phone is not registered.
- NotRegisteredInt: Forward calls when the phone is not registered, international destinations.

.NOTES
Author: Brad S
Version: 1.0.0
#>

enum CallForwardTypes {
    All
    Busy
    BusyInt
    NoAnswer
    NoAnswerInt
    NoCoverage
    OnFailure
    AlternateParty
    NotRegistered
    NotRegisteredInt
}