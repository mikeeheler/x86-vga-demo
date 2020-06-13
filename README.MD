# TUI.COM

## Standards

### Calling Convention

This project uses `stdcall`:

* Parameters are passed via the stack, right-to-left
* The callee cleans up the stack
* Values are returned in EAX/AX/AL
* Functions may modify EAX, ECX, and EDX at will, all other registers
  must be restored prior to return.

## VGA

