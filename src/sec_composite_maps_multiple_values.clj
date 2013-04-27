(ns multiple-values
  (:require [clojure.test :refer :all]))

(defprotocol MultiAssociative
  "An associative structure that can contain multiple values for a key"
  (insert [m key value] "Insert a value into a MultiAssociative")
  (delete [m key value] "Remove a value from a MultiAssociative")
  (get-all [m key] "Returns a set of all values storted at key in a
                    MultiAssociative. Returns the empty set if there
                    are no values."))

(defn- value-set?
  "Helper predicate that returns true if the value is a set which
  represents multiple values in a MultiAssociative"
  [v]
  (and (set? v) (::multi-value (meta v))))

(defn value-set
  "Given any number of items as argumnents, returns a set representing
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftest test-insert
  (testing "inserting to a new key"
    (is (= {:k :v} (insert {} :k :v))))
  (testing "inserting to an existing key (single existing item)"
    (let [m (insert {} :k :v1)]
      (is (= {:k #{:v1 :v2}}
             (insert m :k :v2)))))
  (testing "inserting to an existing key (multiple existing items)"
    (let [m (insert (insert {} :k :v1) :k :v2)]
      (is (= {:k #{:v1 :v2 :v3}}
             (insert m :k :v3))))))

(deftest test-delete
  (testing "deleting a non-present key"
    (is (= {:k :v} (delete {:k :v} :nosuch :nada))))
  (testing "deleting a non-present value"
    (is (= {:k :v} (delete {:k :v} :k :nada))))
  (testing "deleting a single value"
    (is (= {} (delete {:k :v} :k :v))))
  (testing "deleting one of two values"
    (let [m (insert (insert {} :k :v1) :k :v2)]
      (is (= {:k :v1} (delete m :k :v2)))))
  (testing "deleting one of several values"
    (let [m (insert (insert (insert {} :k :v1) :k :v2) :k :v3)]
      (is (= {:k #{:v1 :v2}} (delete m :k :v3))))))

(deftest test-get-all
  (testing "get a non-present key"
    (is (= #{} (get-all {} :nosuch))))
  (testing "get a single value"
    (is (= #{:v} (get-all {:k :v} :k))))
  (testing "get multiple values"
    (is (= #{:v1 :v2} (get-all (insert (insert {} :k :v1) :k :v2) :k)))))


