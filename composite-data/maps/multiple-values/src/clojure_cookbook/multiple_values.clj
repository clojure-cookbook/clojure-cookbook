(ns clojure-cookbook.multiple-values)

(defprotocol MultiAssociative
  "An associative structure that can contain multiple values for a key"
  (insert [m key value] "Insert a value into a MultiAssociative")
  (delete [m key value] "Remove a value from a MultiAssociative")
  (get-all [m key] "Returns a set of all values stored at key in a
                    MultiAssociative. Returns the empty set if there
                    are no values."))

(defn- value-set?
  "Helper predicate that returns true if the value is a set which
  represents multiple values in a MultiAssociative"
  [v]
  (and (set? v) (::multi-value (meta v))))

(defn value-set
  "Given any number of items as arguments, returns a set representing
  multiple values in a MultiAssociative. If there is only one item,
  simply returns the item"
  [& items]
  (if (= 1 (count items))
    (first items)
    (with-meta (set items) {::multi-value true})))

(extend-protocol MultiAssociative
  clojure.lang.Associative
  (insert [this key value]
    (let [v (get this key)]
      (assoc this key (cond
                       (nil? v) value
                       (value-set? v) (conj v value)
                       :else (value-set v value)))))
  (delete [this key value]
    (let [v (get this key)]
      (if (value-set? v)
        (assoc this key (apply value-set (disj v value)))
        (if (= v value)
          (dissoc this key)
          this))))
  (get-all [this key]
    (let [v (get this key)]
      (cond
       (value-set? v) v
       (nil? v) #{}
       :else #{v}))))
