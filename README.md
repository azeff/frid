# frid
Swift version of Firebase's algorithm for unique id generation. They published [blog post](https://firebase.googleblog.com/2015/02/the-2120-ways-to-ensure-unique_68.html) with description of algorithm and shared [javascript version](https://gist.github.com/mikelehen/3596a30bd69384624c11) of it.

Generator creates 20-character string identifiers with the following properties:

1. They're based on timestamp so that they sort *after* any existing ids.
2. They contain 72-bits of random data after the timestamp so that IDs won't collide with other clients' IDs.
3. They sort *lexicographically* (so the timestamp is converted to characters that will sort properly).
4. They're monotonically increasing.  Even if you generate more than one in the same timestamp, the
   latter ones will sort after the former ones.  We do this by using the previous random bits
   but "incrementing" them by 1 (only in the case of a timestamp collision).
