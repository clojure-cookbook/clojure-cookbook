cd .compile

rm -rf /tmp/clojure-cookbook-atlas
git clone https://atlas-server.oreilly.com/git/1234000001500.git /tmp/clojure-cookbook-atlas

lein run ../clojure-cookbook.asciidoc /tmp/clojure-cookbook-atlas

cd /tmp/clojure-cookbook-atlas

git add .
git commit -m "automated update from github repository"
git push

