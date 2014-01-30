(defn greet
  [name]
  (str "Hello, " name "!"))

(doseq [name *command-line-args*]
  (println (greet name)))
