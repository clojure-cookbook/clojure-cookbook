(ns foo.core
  (:gen-class))

(defn -main  [& args]
  (->> args
       (interpose " ")
       (apply str)
       (println "Executed with the following args: ")))
