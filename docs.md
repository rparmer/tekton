# Tekton Flux Integration POC

## Overview
Tekton provides a low level pod orchestration framework that makes it easy to execute tasks in a kubernetes cluster.  These tasks can be chained and ordered into pipeline definitions making it possible to create complete CI/CD solutions.  Tekton uses a multiple layer approach to coordinate a pod execution.  The base component is the `Task` definition.  A Task is composed of one or more steps that define what a Task should do.  Each step contains it's own image definition, parameters, command, etc and are executed in the order they are defined.  A `Pipeline` is composed of one or more Task definitions.  Pipelines also contain their own set of parameters, but unlike Task steps the Pipeline Task's are not guarenteed to run in the order they are defined.  Tekton will try to run as many Tasks in parallel, meaning that Tasks that do not have a direct dependency on another task may run at the same time.  To overcome this each Task ref supports a `runAfter` configuration that defines a list of Tasks that must be completed before that particular Task can run.  To run a Pipeline or Task, a new `PipelineRun` or `TaskRun` resource needs to be created.  These run definitions contain the Pipeline or Task ref that should be ran along with the global params and workspace definitions that will be passed into the run.  A new run resource needs to be created ***for each Pipeline or Task run***.  This can be problematic or difficult to implement in an automated fasion.  To overcome this Tekton can use `TriggerTemplates` and `EventListeners` that can use webhooks to automatically kick of new runs based on certain events.  The TriggerTemplate contains a list of PipelineRun and/or TaskRun resources that should be executed along with a global set of params that can be passed into each run ref.  The EventListeners contain all the filter rules and definitions for which TriggerTemplate to execute when a event happens.  This is where any 'only on main' or 'on new pull request' conditions will be set.  Additionally EventListeners support `TriggerBinding` resources that can be used to extract out values from the payload sent to the EventListener.  These values can then be referenced as params in the TriggerTemplate and then passed into the run resource.

## Outcomes
### Pros
- It works :)
- Easy to setup and configure the core app and features with Flux
- Most of the Tekton pipeline and task features work with Flux
  - Only issue found so far is the `generatedName` metadata options does not work when creating a PipelineRun/TaskRun directly
    - Does not work with `kubectl apply`
    - That option does work if the PipelineRun/TaskRun is created from a TriggerTemplate

### Shortcomings
- Failed pipeline tasks cannot be restarted/retried
  - Entire pipeline must be ran again
- Difficult/confusing to create a working pipeline
  - EventListener > TriggerTemplate & TriggerBinding > Pipeline > Task
  - Workspaces and params work from top down.  So if a Task needs a new param the Task, Pipeline, TriggerTemplate and EventListener may all need to be updated as well

## Summary
For integration into WGE for artifact promotion Tekton seems like a viable solution.  The issue remains that Tekton runs at a much lower level than traditional pipeline tools and even a simple Task change could require cascading changes to higher events in the chain.  If we go down this route we may want to templatize and/or add a ui component within the WGE app to help ease some of these complexities from users.  Another option would be to look into migrating Tekton support into Flux directly.  Something along the lines of 'on source change trigger pipeline' would help remove some of the initial setup steps (ie EventListener webhook) and provide a more Flux native flow.  I'm just not sure how feasible that would be to achieve.