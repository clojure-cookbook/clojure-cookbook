(ns deployer.groups.deployer
    "Node defintions for deployer"
    (:require
     [pallet.core :refer [group-spec server-spec node-spec plan-fn]]
     [pallet.crate.automated-admin-user :refer [automated-admin-user]]
     [pallet.crate.app-deploy :as app-deploy]
     [pallet.crate.runit :as runit]))

(def default-node-spec
  (node-spec
   :image {:os-family :ubuntu}
   :hardware {:min-cores 1}))

(def
  ^{:doc "Defines the type of node deployer will run on"}
  base-server
  (server-spec
   :phases
   {:bootstrap (plan-fn (automated-admin-user))}))

(def
  ^{:doc "Define a server spec for deployer"}
  deployer-server
  (server-spec
   :extends [(app-deploy/server-spec
              {:artifacts
               {:from-maven-repo [{:coord '[your-project-id "0.1.0"]
                                   :path "your-project.jar"}]}})
             (runit/server-spec {})]))

(def
  ^{:doc "Defines a group spec that can be passed to converge or lift."}
  deployer
  (group-spec
   "deployer"
   :extends [base-server deployer-server]
   :node-spec default-node-spec))
