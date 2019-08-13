/**************************************************************************
 *                                                                        *
 *  Algorithmic C (tm) Datatypes                                          *
 *                                                                        *
 *  Software Version: 3.9                                                 *
 *                                                                        *
 *  Release Date    : Fri Oct 12 12:26:10 PDT 2018                        *
 *  Release Type    : Production Release                                  *
 *  Release Build   : 3.9.0                                               *
 *                                                                        *
 *  Copyright 2004-2018, Mentor Graphics Corporation,                     *
 *                                                                        *
 *  All Rights Reserved.                                                  *
 *  
 **************************************************************************
 *  Licensed under the Apache License, Version 2.0 (the "License");       *
 *  you may not use this file except in compliance with the License.      * 
 *  You may obtain a copy of the License at                               *
 *                                                                        *
 *      http://www.apache.org/licenses/LICENSE-2.0                        *
 *                                                                        *
 *  Unless required by applicable law or agreed to in writing, software   * 
 *  distributed under the License is distributed on an "AS IS" BASIS,     * 
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or       *
 *  implied.                                                              * 
 *  See the License for the specific language governing permissions and   * 
 *  limitations under the License.                                        *
 **************************************************************************
 *                                                                        *
 *  The most recent version of this package is available at github.       *
 *                                                                        *
 *************************************************************************/

/*
//  Source:         ac_channel.h
//  Description:    templatized channel communication class
//  Author:         Andres Takach, Ph.D.
*/

#ifndef __AC_CHANNEL_H
#define __AC_CHANNEL_H

#ifndef __cplusplus
# error C++ is required to include this header file
#endif

#include <iostream>
#include <deque>

#if !defined(AC_USER_DEFINED_ASSERT) && !defined(AC_ASSERT_THROW_EXCEPTION)
# include <assert.h>
#endif

// not directly used by this include
#include <stdio.h>
#include <stdlib.h>

// Macro Definitions (obsolete - provided here for backward compatibility)
#define AC_CHAN_CTOR(varname) varname
#define AC_CHAN_CTOR_INIT(varname,init) varname(init)
#define AC_CHAN_CTOR_VAL(varname,init,val) varname(init,val)

////////////////////////////////////////////////
// Struct: ac_exception / ac_channel_exception
////////////////////////////////////////////////

#ifndef __INCLUDED_AC_EXCEPTION
# define __INCLUDED_AC_EXCEPTION
struct ac_exception {
  const char *const file;
  const unsigned int line;
  const int code;
  const char *const msg;
  ac_exception(const char *file_, const unsigned int &line_, const int &code_, const char *msg_)
    : file(file_), line(line_), code(code_), msg(msg_) { }
};
#endif

struct ac_channel_exception {
  enum { code_begin = 1024 };
  enum code {
    read_from_empty_channel                                     = code_begin,
    fifo_not_empty_when_reset,
    no_operator_sb_defined_for_sc_fifo_in,
    no_operator_sb_defined_for_sc_fifo_out,
    no_insert_defined_for_sc_fifo_in,
    no_insert_defined_for_sc_fifo_out 
  };
  static inline const char *msg(const code &code_) {
      static const char *const s[] = {
          "Read from empty channel",
          "fifo not empty when reset",
          "No operator[] defined for sc_fifo_in",
          "No operator[] defined for sc_fifo_out",
          "No insert defined for sc_fifo_in",
          "No insert defined for sc_fifo_out"
      };
      return s[code_-code_begin];
  }
};

///////////////////////////////////////////
// Class: ac_channel
//////////////////////////////////////////

template <class T>
class ac_channel {
public:
  // constructors
  ac_channel();  
  ac_channel(int init);
  ac_channel(int init, T val);

  T read() { return chan.read(); }
  void read(T& t) { t = read(); }
  bool nb_read(T& t) {
    if(size() != 0) {
      read(t);
      return true;
    } else
      return false;
  }
  void write(const T& t) { chan.write(t); }

  bool nb_write(T& t) {
    chan.incr_size_call_count();
    if(chan.num_free()) {
      write(t);
      return true;
    } else
      return false;
  }

  unsigned int size() { 
    chan.incr_size_call_count();
    return chan.size(); 
  }
  bool empty() { return size() == 0; }

  // Return true if channel has at least k entries
  bool available(unsigned int k) const { return chan.size() >= k; }

  void reset() { chan.reset(); } 

  unsigned int debug_size() const { return chan.size(); }

  const T &operator[](unsigned int pos) const { return chan[pos]; }

  bool operator==(const ac_channel &rhs) const { return this->chan == rhs.chan; }
  bool operator!=(const ac_channel &rhs) const { return !operator==(rhs); }

  int get_size_call_count() { return chan.get_size_call_count(); }

#ifdef SYSTEMC_INCLUDED
  void bind(sc_fifo_in<T> &f) { chan.bind(f); }
  void bind(sc_fifo_out<T> &f) { chan.bind(f); }
#endif

private:
# ifndef AC_CHANNEL_ASSERT
#   define AC_CHANNEL_ASSERT(cond, code) ac_assert(cond, __FILE__, __LINE__, code) 
    static inline void ac_assert(bool condition, const char *file, int line, const ac_channel_exception::code &code) {
#     ifndef AC_USER_DEFINED_ASSERT
        if(!condition) {
          const ac_exception e(file, line, code, ac_channel_exception::msg(code));
#        ifdef AC_ASSERT_THROW_EXCEPTION
#         ifdef AC_ASSERT_THROW_EXCEPTION_AS_CONST_CHAR
           throw(e.msg);
#         else
           throw(e);
#         endif
#        else
          std::cerr << "Assert";
          if(e.file) 
            std::cerr << " in file " << e.file << ":" << e.line;
          std::cerr << " " << e.msg << std::endl;
          assert(0);
#        endif
        }
#     else
        AC_USER_DEFINED_ASSERT(condition, file, line, ac_channel_exception::msg(code));
#     endif
    }
# else
#   error "private use only - AC_CHANNEL_ASSERT macro already defined"
# endif

public:
  class fifo {
#ifdef SYSTEMC_INCLUDED
    sc_fifo_in<T> *fifo_in;
    sc_fifo_out<T> *fifo_out;
#else

#if (defined(_MSC_VER) && !defined(__EDG__))
#pragma warning( push )
#pragma warning( disable: 4700 )
#endif
#if (defined(__GNUC__) && ( __GNUC__ == 4 && __GNUC_MINOR__ >= 6 || __GNUC__ > 4 ) && !defined(__EDG__))
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wuninitialized"
#endif
#if defined(__clang__)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wuninitialized"
#endif
    struct fifo_disabled {
      T read() const { T x; return x; }
      void write(const T& t) { }
      unsigned int num_available() const { return 0; }
      unsigned int num_free() const { return 0; }
    };
    fifo_disabled *fifo_in;
    fifo_disabled *fifo_out;
#if (defined(_MSC_VER) && !defined(__EDG__))
#pragma warning( pop )
#endif
#if (defined(__GNUC__) && ( __GNUC__ == 4 && __GNUC_MINOR__ >= 6 || __GNUC__ > 4 ) && !defined(__EDG__))
#pragma GCC diagnostic pop
#endif
#if defined(__clang__)
#pragma clang diagnostic pop
#endif

#endif

    std::deque<T> ch;
    unsigned int rSz;    // reset size
    T rVal;              // resetValue
    int size_call_count;
  public:
    fifo() : fifo_in(0), fifo_out(0), rSz(0), size_call_count(0) {} 
    fifo(int init) : fifo_in(0), fifo_out(0), rSz(init), size_call_count(0) {} 
    fifo(int init, T val) : fifo_in(0), fifo_out(0), rSz(init), rVal(val), size_call_count(0) {} 
    T read() {
      if(fifo_in)
        return fifo_in->read();
      else {
        {
          // If you hit this assert you attempted a read on an empty channel. Perhaps
          // you need to guard the execution of the read with a call to the available()
          // function:
          //    if (myInputChan.available(2)) {
          //      // it is safe to read two values
          //      cout << myInputChan.read();
          //      cout << myInputChan.read();
          //    }
          AC_CHANNEL_ASSERT(size(), ac_channel_exception::read_from_empty_channel);
        }
        T t = ch.front();
        ch.pop_front();
        return t;
      }
    }
    void write(const T& t) {
      if(fifo_out)
        fifo_out->write(t);
      else
        ch.push_back(t);
    }
    unsigned int size() const {
      if(fifo_in)
        return fifo_in->num_available();
      return (int)ch.size();
    }
    unsigned int num_free() const {
      if(fifo_out)
        return fifo_out->num_free();
      return ch.max_size() - ch.size();
    }
    void reset() {
      if(fifo_out) {
        AC_CHANNEL_ASSERT(!size(), ac_channel_exception::fifo_not_empty_when_reset);
      } else {
        ch.clear();
      }
      for (int i=0; i<(int)rSz; i++)
        write(rVal);
    }
    bool operator==(const ac_channel &rhs) const {
      // OJO: comparing pointers, should be by value
      return fifo_in ? fifo_in == rhs.fifo_in : 
             fifo_out ? fifo_out == rhs.fifo_out : ch == rhs.ch;  
    }
    const T &operator[](unsigned int pos) const { 
      AC_CHANNEL_ASSERT(!fifo_in, ac_channel_exception::no_operator_sb_defined_for_sc_fifo_in);
      AC_CHANNEL_ASSERT(!fifo_out, ac_channel_exception::no_operator_sb_defined_for_sc_fifo_out);
      return ch[pos]; 
    }

    void incr_size_call_count() { ++size_call_count; }
    int get_size_call_count() {
      int tmp=size_call_count;
      size_call_count=0;
      return tmp;
    }

#ifdef SYSTEMC_INCLUDED
    void bind(sc_fifo_in<T> &f) { fifo_in = &f; }
    void bind(sc_fifo_out<T> &f) { fifo_out = &f; }
#endif     

    // obsolete - provided here for backward compatibility
    struct iterator {
      iterator operator+(unsigned int pos_) const 
      { return iterator(itr, pos_); }
    private:
      friend class fifo;
      iterator(const typename std::deque<T>::iterator &itr_, unsigned int pos=0)
        : itr(itr_) { if (pos) itr += pos; }
      typename std::deque<T>::iterator itr;
    };
    iterator begin() { return iterator(ch.begin()); }
    void insert(iterator itr, const T& t) { 
      AC_CHANNEL_ASSERT(!fifo_in, ac_channel_exception::no_insert_defined_for_sc_fifo_in);
      AC_CHANNEL_ASSERT(!fifo_out, ac_channel_exception::no_insert_defined_for_sc_fifo_out);
      ch.insert(itr.itr,t);
    }
  };
  fifo chan;

private:
  // Prevent the compiler from autogenerating these.
  //  (This enforces that channels are always passed by reference.)  
  ac_channel(const ac_channel< T >&); 
  ac_channel& operator=(const ac_channel< T >&);
};

template <class T>
ac_channel<T>::ac_channel() : chan() {}

template <class T>
ac_channel<T>::ac_channel(int init) : chan(init)
{
  for (int i=init; i>0; i--) {
    T dc; 
    write(dc);
  }
}

template <class T>
ac_channel<T>::ac_channel(int init, T val) : chan(init, val)
{
  for (int i=init; i>0; i--)
    write(val);
}

template<class T>
inline std::ostream& operator<< (std::ostream& os, ac_channel<T> &a)
{
  for (unsigned int i=0; i<a.size(); i++) {
    if (i > 0) os << " ";
    os << a[i];
  }
  return os;
}

/* undo macro adjustments */
#ifdef AC_CHANNEL_ASSERT
#  undef AC_CHANNEL_ASSERT
#endif

#endif
