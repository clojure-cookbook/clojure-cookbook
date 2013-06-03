(ns clojure-cookbook.markov-sample
  (:require [clojure.string :as s]
            [clojure.java.io :as io]))

(def token-re
  "A regular expression defining a 'token'; either a word, or relevant
   punctuation."

  #"[a-z']+|[.!?;:,]{1}+")

(defn lines
  "Given an open reader, return a lazy sequence of lines"
  [^java.io.BufferedReader reader]
  (take-while identity (repeatedly #(.readLine reader))))

(defn tokens
  "Given a reader, return a lazy sequence of cleaned-up tokens"
  [reader]
  (->> reader
       lines
       (filter identity)
       (map s/lower-case)
       (mapcat #(re-seq token-re %))))

(defn build-model
  "Given a sequence of tokens, construct a Markov model of it.

  Also takes configuration parameter 'n' to indicate the number
  of tokens of each point in the the model's state, which greatly
  influences the size of the model.

  The returned model is a map. They keys are token sequences of length
  n, representing states of the markov model. The values are maps, the
  keys of which are a single token, and the values of which are
  integers representing number of times that token occurs after the corresponding state.

  Sample output, with n = 2:

      { [under the] {sea 202, ground 63},
        [over the]  {rainbow 102, hills 23} }
  "
  [tokens n]
  (reduce (fn [model part]
            (update-in model
                       [(butlast part) (last part)]
                       (fnil inc 0)))
          {}
          (partition (inc n) 1 tokens)))

(defn sample
  "Given a map of keys to  occurrence counts, return a random key,
  respecting the probability distribution reflected in the map.

  For example, given the map {:a 10 :b 15 :c 25}, the function should
  return :c approximately 50% of the time, :b 30% of the time, and :a
  20%."
  [m]
  (let [total (reduce + (vals m))
        pick (inc (rand-int total))]
    (loop [cumulative 0
           remaining (sort-by val m)]
      (let [c (+ cumulative (val (first remaining)))]
        (if (<= pick c)
          (key (first remaining))
          (recur c (rest remaining)))))))

(defn states
  "Given a Markov model with a state size of n, and a starting state,
  return a lazy sequence of states in a Markov Chain."
  [model state]
  (iterate (fn [s]
             (concat (drop 1 s) [(sample (model s))]))
           state))

(defn render
  "Given a sequence of markov states, render into more readable text."
  [states]
  (->> states
       (map first)
       flatten
       (map (fn [t] (if (re-matches #"|[.!?;:,]" t)
                      t
                      (str " " t))))
       (reduce str)))

(defn markov-text
  "Function to tie it all together. Given a uri and a state size,
  returns some Markov generated text of the specified length. Uses a
  random state as the initial state."
  [uri n length]
  (let [r (io/reader uri)
        model (build-model (tokens r) n)]
    (render (take length (states model (rand-nth (keys model)))))))
