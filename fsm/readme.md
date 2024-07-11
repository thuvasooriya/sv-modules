# finite-state machine

> `state` : a situation of a system depending on the previous inputs and causes a reaction on following inputs

> `inital state` : where the execution of the machine starts

> `state transition` : description of state goes to which state for a given input

> `sequential design` : a computation model that can be used to simulate sequential logic.
> a.k.a. mathematical model or behavior model as in it describes and controls the behavior or the execution flow `not to be confused with verilog's behaviour modeling`

> sequential design is formally known as fsm

> every state machine we implement in computers have finite number of states (afaik)
> hence the name finite-state machine or fsm

> based on the **current state** and the **input** fsm performs **state transition** and produces outputs.
> depending on the fsm type `states` **and/or** `transitions` produce outputs

## types

some basic types like mealy and moore and some complex types like harel and uml statecharts exist.

### mealy

- output depends on `present state` and `input`
- **fewer** states and **less** hardware required
- reacts **faster** to input
- **difficult** to do practical & reliable design
- states are synced to clock but **_output generation is async_**

### moore

- output only depends on `present state`
- **more** states and **more** logic (hardware) is required to decode the output
- reaction time is **more** as more logic introduces delays
- **easier** to do practical and stable design
- states **and** outputs are _synced_ to clock

## examples

### directory structure

```text
--- --- system verilog modules - simulated with -g2012 in iverilog
--- sqd{sequence}meno.sv - non overlapping sequence detector of {sequence} as mealy state machine
--- sqd{sequence}mono.sv - non overlapping sequence detector of {sequence} as moore state machine
--- sqd{sequence}me.sv - overlapping sequence detector of {sequence} as mealy state machine
--- sqd{sequence}mo.sv - overlapping sequence detector of {sequence} as moore state machine

--- --- legacy verilog modules - simulated without g flag (-g2005)
--- sqd{sequence}meno.v - non overlapping sequence detector of {sequence} as mealy state machine
--- sqd{sequence}mono.v - non overlapping sequence detector of {sequence} as moore state machine
--- sqd{sequence}me.v - overlapping sequence detector of {sequence} as mealy state machine
--- sqd{sequence}mo.v - overlapping sequence detector of {sequence} as moore state machine

--- --- testing files
--- uvm*.sv - trying out uvm style test bench : wip
--- *.sv    - accompanying modules
```

### sequence detectors

sequence detectors (a.k.a. snail on the line problems) are a good way to understand the finite-state machines
as analysing the code and drawing state diagrams are relatively easier

#### 0110 detector

<p align="center"><img src="https://i.imgur.com/VUvfrwM.jpg"/></p>

### references

1. https://www.itemis.com/en/products/itemis-create/documentation/user-guide/overview_what_are_state_machines
2. https://vlsiverify.com/verilog/fsm-and-sequence-detector/
3. https://scholarbasta.com/what-is-fsm-write-mealy-and-moore-state-machine-using-verilog/
4. https://circuitcove.com/design-examples-fsm/
5. https://yue-guo.com/2019/03/19/sequence-detector-1010-moore-machine-mealy-machine-overlapping-non-overlapping/
