(require
 '[deployer.groups.deployer :refer [deployer]])

(defproject deployer
  :provider {:jclouds
             {:node-spec
              {:image {:os-family :ubuntu :os-version-matches "12.04"
                       :os-64-bit true}}}}

  :groups [deployer])
