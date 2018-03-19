/// Small classes and functions of a miscellaneous nature that are reusable across all of NVDLA.
///
/// Many of the functions in this file were adapted from the Bit Twiddling Hacks web page:
///     https://graphics.stanford.edu/~seander/bithacks.html
///
/// Never wildcard import this package (import nvdla_tools::*;).  Wildcard imports will lead
/// to name collisions and compilation errors.  You may import indivdual functions 
/// (import nvdla_tools::min;) or qualify functions with the package name in the function call
/// ( nvdla_tools::min( a, b ); )
///
//


// !! NOTICE
// Never wildcard import this package (import nvdla_tools::*;).  Wildcard imports will lead
// to name collisions and compilation errors.  You may import indivdual functions 
// (import nvdla_tools::min;) or qualify functions with the package name in the function call
// ( nvdla_tools::min( a, b ); )

`include "uvm_macros.svh"

package nvdla_tools;

import uvm_pkg::*;

// A parameterized max function.  The parameter defines the type of the input arguments and return
// type.  Any type for which the > operator is defined may be used.
virtual class max #( type Targ = longint unsigned );
    static function Targ call( Targ a, Targ b );
        return (a > b) ? a : b;
    endfunction
endclass

// A parameterized min function.  The parameter defines the type of the input arguments and return
// type.  Any type for which the < operator is defined may be used.
virtual class min #( type Targ = longint unsigned );
    static function Targ call( Targ a, Targ b );
        return (a < b) ? a : b;
    endfunction
endclass

endpackage : nvdla_tools
