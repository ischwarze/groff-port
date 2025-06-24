# Porting and debugging GNU roff

This repository contains work in progress on the
[textproc/groff](https://cvsweb.openbsd.org/cgi-bin/cvsweb/ports/textproc/groff/)

The reason why such a repository is needed is twofold:

 1. Recent [GNU roff](https://www.gnu.org/software/groff/) development
    suffers from massive amounts of regressions and gratuitious changes
    that make providing a stable groff port very hard.

 2. The gnulib, automake, and autoconf build system used by groff
    degrades portability of the software to the point that getting
    it to build at all is quite hard and tracking down issues
    becomes outright hellish.

In spite of several attempts, the combination of the two above
problems has prevented me from updating the groff port in OpenBSD
for about two years now, in particular since the second problem
keeps distracting from serious work on the actual issues in the
first problem class.   I have a large heap of patches lying around
on my private systems that contribute to partial solutions, but do
not form a coherent whole, and their volume and trickiness has
repeatedly caused me to lose track of what needs to be done next.

This repository is an attempt at systematically organising the large
number of patches needed to get groff first to build correctly,
then to work correctly.

Branches are set up as follows:

 * The **cvs** branch at the root of the repository contains
   the port in the OpenBSD ports CVS because the ultimate goal is
   to update groff in OpenBSD to 1.23 and then later to 1.24
   once that is released.

 * The **1.23** branch contains what is needed to get groff 1.23
   to build and work correctly.  Most of the work here is done,
   but final completion has not been reached yet.

Pull requests will *not* be accepted.  If you have suggestions,
send email to schwarze at openbsd dot org.  Such mail can optionally
contain in-line patch(1)es.  Mail containing HTML, Markdown,
or MIME attachments will be silently deleted.
