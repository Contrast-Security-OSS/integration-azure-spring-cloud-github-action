# Documentation Diagrams

## Phase 1: Unpacking the Github Action `Initial Docker Build`

This phase packages the overall github action into a self-encapsulated unit that can be executed without any additional dependencies.

![phase-1](https://github.com/admiralappsec/springone-github-action/blob/main/diagrams/springone-ga.png)

<hr />

## Phase 2: Provisioning the Automation `Second Docker Build`

This phase provisions the docker container that will perform the automation prescribed for this specific github action.

![phase-2](https://github.com/admiralappsec/springone-github-action/blob/main/diagrams/springone-ga2.png)

<hr />

## Phase 3: Action Automation Flow `Execution`

This phase performs the automation of the github action. The action steps are highlighted below.

![phase-3](https://github.com/admiralappsec/springone-github-action/blob/main/diagrams/springone-ga3.png)
