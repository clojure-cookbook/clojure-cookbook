(ns foo
  (:require foo.util))

(defn -main
  [& args]
  (doseq [name args]
    (println (foo.util/greet name))))
