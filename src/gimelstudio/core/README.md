# Gimel Studio Core

The Gimel Studio core handles the rendering and node evalution backend.


## Core Concepts

**Node Evaluation**

The node evaluation is basically functions calling other functions in sequence.


**Import/export data**

Each node is defined by a unique id generated upon creation.


**Id Pool**

Keep an id pool that won't allow another id that is the same. This is important to avoid node conflicts.

if generated_id in ids:
    regenerate an id
else:
    keep and use the id


**Node cache**

INPUT nodes shouldn't need dynamic cache -rather just cache the value after it has been set

edited_flag is set for the node being edited and when edited_flag is True, use the cache for the parameter (image) instead of re-evalating nodes further down the tree.

edited_flag = getthevalueofthedirtyflag() # aka: is this node being edited?
if edited_flag == True:
    value = usecache() # use a copy of the cache
else:
    value = evalprop() # further evaluation
edited_flag = False