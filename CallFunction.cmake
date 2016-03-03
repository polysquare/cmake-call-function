# /CMakeCallFunction.cmake
#
# Call functions dynamically by name. Internally, this function uses
# variable_watch and a global property to keep track of how many times
# a function has been called.
#
# Calling functions in this way can be quite slow and will increase
# CMake's memory usage. It should be avoided if posible.
#
# See /LICENCE.md for Copyright information

# cmake_call_function
#
# Call the 'callable' function named FUNCTION_NAME, passing arguments
# as specified in ARGN.
#
# Only 'callable' functions can be called dynamically using this function.
# 'callable' functions abide to the dynamic calling convention, where all
# arguments to the function are specified in a list variable named
# CALLER_ARGN. That list can be parsed using a module like ParseArguments.
#
# Regular functions which specify their arugments after the function
# name, or rely on ARGN, cannot be called with this function. The result
# is not defined by this module.
function (cmake_call_function FUNCTION_NAME)

    get_property (_INTERNAL_CALL_COUNT
                  GLOBAL PROPERTY _INTERNAL_CALL_COUNT)

    if (NOT _INTERNAL_CALL_COUNT)

        set (_INTERNAL_CALL_COUNT 0)

    endif ()

    math (EXPR _INTERNAL_CALL_COUNT "${_INTERNAL_CALL_COUNT} + 1")

    set_property (GLOBAL PROPERTY _INTERNAL_CALL_COUNT ${_INTERNAL_CALL_COUNT})

    # These variables are used by the called function beneath us as part of
    # a "calling convention". CALLER_ARGN essentially functions like ARGN
    # for the called function and CALLED_FUNCTION_NAME specifies the name of
    # the last called function in this call stack.
    set (CALLER_ARGN ${ARGN}) # NOLINT:unused/var_in_func
    set (CALLED_FUNCTION_NAME ${FUNCTION_NAME}) # NOLINT:unused/var_in_func
    variable_watch (_${_INTERNAL_CALL_COUNT}_${FUNCTION_NAME}
                    ${FUNCTION_NAME})
    set (_${_INTERNAL_CALL_COUNT}_${FUNCTION_NAME} "_")

    set (ARGN_VALUES)

    foreach (ARG ${ARGN})

        if (DEFINED "${ARG}")

            set (${ARG} "${${ARG}}" PARENT_SCOPE)

        endif ()

    endforeach ()

endfunction ()