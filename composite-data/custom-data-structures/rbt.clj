(require '[clojure.core.match :refer [match]])

(defn- balance
  "Ensures the given sub-tree stays balanced by rearranging black nodes
  which have at least one red child and one red grandchild"
  [tree]
  (match [tree]
         [(:or ;; Left child red with left red grandchild
               [:black [:red [:red a x b] y c] z d]
               ;; Left child red with right red grandchild
               [:black [:red a x [:red b y c]] z d]
               ;; Right child red with left red grandchild
               [:black a x [:red [:red b y c] z d]]
               ;; Right child red with right red grandchild 
               [:black a x [:red b y [:red c z d]]])] [:red [:black a x b]
                                                            y
                                                            [:black c z d]]
               :else tree))

(defn- insert-val
  "Inserts x in tree.
  Returns a node with x and no children if tree is nil.

  Returned tree is balanced. See also `balance`"
  [tree x]
  (let [ins (fn ins [tree]
              (match tree
                     nil [:red nil x nil]
                     [color a y b] (cond
                                    (< x y) (balance [color (ins a) y b])
                                    (> x y) (balance [color a y (ins b)])
                                    :else tree)))
        [_ a y b] (ins tree)]
    [:black a y b]))

(defn- find-val
  "Finds value x in tree"
  [tree x]
  (match tree
         nil nil
         [_ a y b] (cond
                    (< x y) (recur a x)
                    (> x y) (recur b x)
                    :else x)))


(defn- rb-tree->tree-seq
  "Returns a seq of all nodes in an red-black tree."
  [rb-tree]
  (tree-seq sequential? (fn [[_ left _ right]]
                          (remove nil? [left right]))
            rb-tree))

(defn rb-tree->seq
  "Convert a red-black tree to a seq of its values."
  [rb-tree]
  (map (fn [[_ _ val _]] val) (rb-tree->tree-seq rb-tree)))

(defprotocol IRedBlackTree
  (find [this x] "Check if a value exists in an RBT"))

(deftype RedBlackTree [tree]
  IRedBlackTree
  (find [this n] (find-val tree n))
  clojure.lang.ISeq
  (cons [self v] (->RedBlackTree (insert-val tree v)))
  (empty [self] (->RedBlackTree nil))
  (equiv [self o] (if (instance? RedBlackTree o)
                    (= (sort (seq self)) (sort (seq o)))
                    false))
  (first [this] (first (rb-tree->seq tree)))
  (next [this] (next (rb-tree->seq tree)))
  (more [this] (rest (rb-tree->seq tree)))
  (seq [this] (if tree (rb-tree->seq tree)))
  Object
  (toString [this] (pr-str this)))

(defmethod print-method RedBlackTree [o ^java.io.Writer w]
  (.write w (str "#rbt " (pr-str (.tree o)))))

(defn rbt
 "Create a new RedBlackTree with the contents of coll."
 [coll]
 (into (->RedBlackTree nil) coll))

(defn red-black-tree
  "Creates a new RedBlackTree containing the args."
  [& args]
  (rbt args))

