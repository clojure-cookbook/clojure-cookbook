(ns clojure-cookbook.multiple-values-test
  (:require [clojure-cookbook.multiple-values :refer :all]
            [clojure.test :refer :all]))

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