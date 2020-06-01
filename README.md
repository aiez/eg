<a name=top><img align=right width=400 src="https://github.com/aiez/eg/blob/master/etc/img/dragon.png">
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


Imagine  that, very quickly, we can find  simple models that  let us succinctly descrine the world around us. In that world, models are easy to grow and maintain. Such models can be easily understood, so we can use them to find what matters most (or least). Further we audit such models to find and fixes sources of biases
in their conclusions. Lastly, such models are not resource intensive to build or deploy so anyone can build them and everyone everywhere can use them.

Do you live in that work? Have you checked?
Before you waste time and money (and   much CPU) to build complex
and opaque AI models, have you first tried something simpler?

For example, all the AI methods explored here are quick to code and
fast to run.  If you applied them to your problems then, at  the
very least, you will get a baseline system which you could use to
show the  superiority   of  any other other, seemingly more
sophisticated, method.  And at the very most, if these simple methods
work well, then you have avoided all that extra modeling.

Ultimately it is an experimental issue whether or not
simplicity-first works for some new problem.  Hence, we call this
book "Is AI Simple?" and we offer you the following challenge.  We
invite you to apply our methods to your own problems, then tell us
how it all goes.  In this way, with time, we will build up lists
of problems that should (or should not) be tackled using simpler
AI.

This book is in two parts. Firstly, some case studies are presented
where "simplicity-first" performed very well indeed.  Secondly,
there are 15 coding challenges aimed at teaching programmers how
to write simpler AI systems:

- These challenges could be used as a guided self-study or as the
  basis of a graduate class on programming AI systems.  Each challenge
  comes with just enough theory to understand the problem, as well
  as numerous suggestions on how this code might be improved.
- Each challenge comes with a fully working example, which you
  need to your favorite language.  You have mastered the challenge
  when your unit tests produce similar output to our unit tests.

For reasons of simplicity and portability (especially to IOT devices),
we code our examples in LUA-- which you can just treat as a executable
specification (so you will not need to code in LUA to use this
book).


<img align=right width=400 src="https://github.com/aiez/eg/blob/master/etc/img/network.png">

## On Simplicity

Less. Plz.     
-- timm

Less, but better.    
-- Deiter Rams

Truth is shorter than fiction.   
-- Irving Cohen

...pursue ultimate simplicity...
-- Marie Kondō

It's easy to be heavy; hard to be light.     
-- G.K. Chesterton

Simplicity is the ultimate sophistication.     
-- William James

Or, rather, let us be more simple and less vain.      
-- Jean-Jacques Rousseau

Half of mathematics is the art of saving space.    
-- Mokokoma Mokhonoana

Our life is frittered away by detail. Simplify, simplify.    
-- Henry David Thoreau

Don't use a big word where a diminutive one will suffice.    
-- Anon

One must learn to be simple, anyone can manage to be complex.   
-- Amit Kalantri

One day I will find the right words, and they will be simple.   
-- Jack Kerouac

The art of being wise is the art of knowing what to overlook.     
-- William James

For I am a bear of very little brain and long words bother me.    
-- Winnie the Pooh

Life only puzzles us because we're not simple enough to understand it.
-- Marty Rubin

Truth is ever to be found in simplicity, and not in the multiplicity and confusion of things.  
-- Issac Newton

As complexity rises, precise statements lose meaning, and meaningful statements lose precision.   
-- Lotfi Zadeh

The computing scientists main challenge is not to get confused by the complexities of (their) own making.    
-- Edsger  Dijkstra

Simplicity is a great virtue but it requires hard work to achieve it and education to appreciate it. And to make matters worse: complexity sells better.    
― Edsger Dijkstra

## Rules for Simpler AI

- The goal is not models, but insight. Every answer should propose N better questions for round i+1. 
  Find and cluster space of possible solutions. Report a summary of each cluster.

## Plan

When I first meet simplicity. 2 pages, references, code.

- Greg Gay: BORE

