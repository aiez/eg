<a name=top><img align=right width=280 src="https://pngimage.net/wp-content/uploads/2019/05/silueta-planetas-png-.png">
<h1><a href="/README.md#top">Is AI Easy?</a></h1> 
<p> <a
href="https://github.com/aiez/eg/blob/master/LICENSE">license</a> :: <a
href="https://github.com/aiez/eg/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/aiez/eg/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/aiez/eg/issues">issues</a> :: <a
href="https://github.com/aiez/eg/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/aiez/eg/blob/master/CONTACT.md#top">contact</a> </p><p> 
<img src="https://img.shields.io/badge/license-mit-red"><img 
src="https://img.shields.io/badge/language-lua-orange"><img 
src="https://img.shields.io/badge/purpose-ai,se-blueviolet"><img 
src="https://img.shields.io/badge/platform-mac,*nux-informational"><a 
     href="https://travis-ci.org/github/sehero/lua"><img 
src="https://travis-ci.org/aiez/eg.svg?branch=master"></a><a 
     href="https://zenodo.org/badge/latestdoi/263210595"><img 
src="https://zenodo.org/badge/263210595.svg" alt="DOI"></a><a 
     href='https://coveralls.io/github/aiez/lua?branch=master'><img i
src='https://coveralls.io/repos/github/aiez/eg/badge.svg?branch=master' alt='Coverage Status' /></a></p>
<em>The computing scientists main challenge is not to get confused by the complexities of (their) own making.</em><br>  
-- E.W. Dijkstra<hr>


Are you tired of complex AI models that are slow to build and hard to explain?

Researchers usually seek solutions that are more intricate and complex;
Yet empirically and theoretically, sometimes, the world we can know is very simple;

For over a decade, researchers at the RAISE lab (AI for SE, and SE for AI) have explored a
_simplicity conjecture_. 
If a model can be generated from a table of data, then that table contains enough examples to learn that model.
That is, many rows are actually echoes of a smaller number of underlying effects called prototypes.

we were so foolish as to try to build high-dimensional models, we would fail as the region where we can find related examples would become vanishingly small. Note that this is often called the curse of dimensionality.

- <em>When the dimensionality increases, the volume of the space increases so
 fast that the available data becomes sparse. This sparsity is problematic for any 
method that requires statistical significance. In order to obtain a statistically 
sound and reliable result, the amount of data needed to support the result often grows
 exponentially with the dimensionality.</em> -- Wikipedia

Note this curse can also be a blessing:

- Because it is impossible to find the data to support bigger models, then all we need ever do is build small ones;
- Which, in turn, means that we might be able to build those small models for just a little data;
- Which also means that we need only share small amounts of data.




