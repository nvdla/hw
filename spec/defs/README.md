# DEFS: project level macros for multiple projects build

## <project>.spec for each project,

## subrutine supported
### log2
    Description;:
    return log 2 value 
    Example:
    %define LOG2_OF_FOO log2(128) // same as %define LOG2_OF_FOO 7
### max
    Description;:
    return max value among various inputs
    Example:
    %define MAX_OF_FOO max(FOO_a,FOO_b,FOO_c)
### min
    Description;:
    return min value among various inputs
    Example:
    %define MIN_OF_FOO min(FOO_a,FOO_b,FOO_c)
### pow2
    Description;:
    return power of 2 
    Example:
    %define POW2_OF_FOO pow2(8) // same as %define LOG2_OF_FOO 256
### floor
    Description;:
    return the max integer value less than or equal to input
    Example:
    %define FLOOR_OF_FOO floor(LOG2_OF_FOO/3) // LOG2_OF_FOO need be defined above, same as %define FLOOR_OF_FOO 2
### ceil
    Description;:
    return the min integer value larger than or equal to input
    Example:
    %define CEIL_OF_FOO ceil(LOG2_OF_FOO/3) // LOG2_OF_FOO need be defined above, same as %define FLOOR_OF_FOO 3

