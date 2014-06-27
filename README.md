GENius [![Build Status](https://circleci-badges.herokuapp.com/offerijns/genius/df82773234f9df260c4f35777c639ed807744bb4)](https://circleci.com/gh/offerijns/genius/)
=================

GENius is a tool that helps those interested in synthetic biology build a circuit of logical operators to control a biological process. These processes can be modified to gain insight into what would happen if some bricks (logical operators or a circuit) were to be omitted, inserted or modified. This would help researchers to gain insight into possible applications of synthetic biology and students to gain knowledge into how synthetic biology works.


Workflow
------------------

1. Anything in the master branch is deployable
2. To work on something new, create a descriptively named branch off of master (ie: new-oauth2-scopes)
3. Commit to that branch locally and regularly push your work to the same named branch on the server
4. When you need feedback or help, or you think the branch is ready for merging, open a pull request
5. After someone else has reviewed and signed off on the feature, you can merge it into master
6. Once it is merged and pushed to ‘master’, you can and should deploy immediately

<small>Source: [Scott Chacon - GitHub Flow](http://scottchacon.com/2011/08/31/github-flow.html)</small>

You can follow this workflow like this:

```
git branch feature-or-fix-description
git checkout feature-or-fix-description
# make some changes
git add .
git commit -m "Add this" # start with a verb in present tense
git push origin feature-or-fix-description
# open pull request on github
# merge & close PR on github
git checkout master
git branch -D feature-or-fix-description
git pull origin master
```



Software packages
--------------

We use the following libraries and software packages:

1. [AngularJS](http://angularjs.org/) - MVC-based Javascript framework
2. [hood.ie](http://hood.ie/) - offline first database
3. [jQuery](http://jquery.com/) - Javascript library
4. [Bootstrap](http://getbootstrap.com/) - CSS framework
5. [SASS](http://sass-lang.com/) - better CSS
6. [Coffeescript](http://coffeescript.org/) - better Javascript
7. [Font Awesome](http://fortawesome.github.io/Font-Awesome/) - icon package
8. [Underscore.js](http://underscorejs.org/) - functional programming for Javascript
9. [Yeoman](http://yeoman.io/) - scaffolding, building, testing, and dependency management


Installation & running
-------------

### Installation


First, you need to install [hood.ie](http://hood.ie/#installation), [Ruby](https://www.ruby-lang.org/en/installation/) and [Compass](http://compass-style.org/install). As hood.ie suggests you also need to install [CouchDB](http://couchdb.apache.org/). 

```
cd ~  

git clone https://github.com/offerijns/genius.git

cd genius
npm install
```

#### Windows Installation

After installing all the modules, head to `.\web\node_modules\hoodie-server\node_modules\multicouch\lib` and open multicouch.js.

Here edit line 17:

```javascript
win_bin = process.arch == "x86" ? 'C:\\Program Files (x86)\\Apache Software Foundation\\CouchDB\\bin\\erl.exe' : 'C:\\Program Files\\Apache Software Foundation\\CouchDB\\bin\\erl.exe';
```
And change it to the following statement:

```javascript
win_bin = 'C:\\Program Files (x86)\\Apache Software Foundation\\CouchDB\\bin\\erl.exe';
```

### Local server

The first time, you will have to set the admin password for the hood.ie database server, which should be 'genius'.

```
cd ~/genius
grunt serve
```

### Tests

```
cd ~/genius
npm test // unit tests
npm run protractor // end-to-end tests
```
