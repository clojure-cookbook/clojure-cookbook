(ns clojure-cookbook.compile
  (:refer-clojure :exclude [compile])
  (:require [clojure.java.io :as io]
            [clojure.string :as s]))

(declare compile)

(defn transform-includes
  "Given a string representing an asciidoc file, return a new string
  with the includes transformed to a flat directory structure. As a
  side effect, compile & copy the included file."
  [contents file output-dir root-dir]
  (reduce (fn [content original-path]
            (let [f (io/file (.getParent file) original-path)
                  path (compile f output-dir root-dir)]
              (if path
                (s/replace content original-path path)
                content)))
          contents
          (map second (re-seq #"include::(.+)\[" contents))))

(defn transform
  "Given a string representing an asciidoc file, return a new string
  with appropriate transformations in place."
  [contents file output-dir root-dir]
  (-> contents
      (transform-includes file output-dir root-dir)))

(defn filename
  "Given a filename, a root directory containing the filename, and an
  output directory, return a new filename relative to the output
  directory."
  [file root-dir]
  (let [root-path (.getCanonicalPath root-dir)
        file-path (.getCanonicalPath file)]
    (-> file-path
        (s/replace root-path "")
        (s/replace #"^/" "")
        (s/replace "/" "__"))))

(defn compile
  "Copy an asciidoc file to the output directory, performing
  transformations appropriate to the provided level. Returns the
  output filename of the emitted asciidoc."
  [file output-dir root-dir]
  (if (.isFile file)
    (let [contents (slurp file)
          new-contents (transform contents file output-dir root-dir)
          fname (filename file root-dir)
          outfile (io/file output-dir fname)]
      (io/make-parents outfile)
      (spit outfile new-contents)
      fname)
    (println "WARNING: asciidoc file does not exist:" file)))

(defn -main
  [& args]
  (if (= 2 (count args))
    (let [file (io/file (first args))
          output-dir (io/file (second args))]
      (compile file output-dir (.getParentFile file)))
    (println "Usage: lein run <root-asciidoc> <output-dir>")))