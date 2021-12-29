# Barnab.AutoBalance
A mod for Northstar servers which automatically balances teams.

### ConVars

`autobal_interval` : Float, Default=10.0, The time between auto-balance checks 

`autobal_threshold` : Integer, Default=2, How many more players one team must have over the other before any players are moved to the other team

`autobal_debug` : Boolean, Default=0, Whether to enable debug mode (skips checks for lobby and incompatible modes, as well as whether the threshold is met). I wouldn't recommend enabling this
