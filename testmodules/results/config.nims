--path:"../.."
--threads:on
import "../../config.nims"

when fileExists("nimble.paths"):
  include "nimble.paths"
